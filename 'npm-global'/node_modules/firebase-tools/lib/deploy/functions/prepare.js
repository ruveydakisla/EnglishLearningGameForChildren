"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.loadCodebases = exports.resolveCpuAndConcurrency = exports.inferBlockingDetails = exports.updateEndpointTargetedStatus = exports.inferDetailsFromExisting = exports.prepare = exports.EVENTARC_SOURCE_ENV = void 0;
const clc = require("colorette");
const backend = require("./backend");
const build = require("./build");
const ensureApiEnabled = require("../../ensureApiEnabled");
const functionsConfig = require("../../functionsConfig");
const functionsEnv = require("../../functions/env");
const runtimes = require("./runtimes");
const validate = require("./validate");
const ensure = require("./ensure");
const functionsDeployHelper_1 = require("./functionsDeployHelper");
const utils_1 = require("../../utils");
const prepareFunctionsUpload_1 = require("./prepareFunctionsUpload");
const prompts_1 = require("./prompts");
const projectUtils_1 = require("../../projectUtils");
const logger_1 = require("../../logger");
const triggerRegionHelper_1 = require("./triggerRegionHelper");
const checkIam_1 = require("./checkIam");
const error_1 = require("../../error");
const projectConfig_1 = require("../../functions/projectConfig");
const v1_1 = require("../../functions/events/v1");
const serviceusage_1 = require("../../gcp/serviceusage");
const applyHash_1 = require("./cache/applyHash");
const backend_1 = require("./backend");
const functional_1 = require("../../functional");
exports.EVENTARC_SOURCE_ENV = "EVENTARC_CLOUD_EVENT_SOURCE";
async function prepare(context, options, payload) {
    var _a, _b;
    const projectId = (0, projectUtils_1.needProjectId)(options);
    const projectNumber = await (0, projectUtils_1.needProjectNumber)(options);
    context.config = (0, projectConfig_1.normalizeAndValidate)(options.config.src.functions);
    context.filters = (0, functionsDeployHelper_1.getEndpointFilters)(options);
    const codebases = (0, functionsDeployHelper_1.targetCodebases)(context.config, context.filters);
    if (codebases.length === 0) {
        throw new error_1.FirebaseError("No function matches given --only filters. Aborting deployment.");
    }
    for (const codebase of codebases) {
        (0, utils_1.logLabeledBullet)("functions", `preparing codebase ${clc.bold(codebase)} for deployment`);
    }
    const checkAPIsEnabled = await Promise.all([
        ensureApiEnabled.ensure(projectId, "cloudfunctions.googleapis.com", "functions"),
        ensureApiEnabled.check(projectId, "runtimeconfig.googleapis.com", "runtimeconfig", true),
        ensure.cloudBuildEnabled(projectId),
        ensureApiEnabled.ensure(projectId, "artifactregistry.googleapis.com", "artifactregistry"),
    ]);
    const firebaseConfig = await functionsConfig.getFirebaseConfig(options);
    context.firebaseConfig = firebaseConfig;
    let runtimeConfig = { firebase: firebaseConfig };
    if (checkAPIsEnabled[1]) {
        runtimeConfig = Object.assign(Object.assign({}, runtimeConfig), (await (0, prepareFunctionsUpload_1.getFunctionsConfig)(projectId)));
    }
    context.codebaseDeployEvents = {};
    const wantBuilds = await loadCodebases(context.config, options, firebaseConfig, runtimeConfig, context.filters);
    const codebaseUsesEnvs = [];
    const wantBackends = {};
    for (const [codebase, wantBuild] of Object.entries(wantBuilds)) {
        const config = (0, projectConfig_1.configForCodebase)(context.config, codebase);
        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
        const userEnvOpt = {
            functionsSource: options.config.path(config.source),
            projectId: projectId,
            projectAlias: options.projectAlias,
        };
        const userEnvs = functionsEnv.loadUserEnvs(userEnvOpt);
        const envs = Object.assign(Object.assign({}, userEnvs), firebaseEnvs);
        const { backend: wantBackend, envs: resolvedEnvs } = await build.resolveBackend(wantBuild, firebaseConfig, userEnvOpt, userEnvs, options.nonInteractive);
        let hasEnvsFromParams = false;
        wantBackend.environmentVariables = envs;
        for (const envName of Object.keys(resolvedEnvs)) {
            const isList = (_a = resolvedEnvs[envName]) === null || _a === void 0 ? void 0 : _a.legalList;
            const envValue = (_b = resolvedEnvs[envName]) === null || _b === void 0 ? void 0 : _b.toSDK();
            if (envValue &&
                !resolvedEnvs[envName].internal &&
                (!Object.prototype.hasOwnProperty.call(wantBackend.environmentVariables, envName) || isList)) {
                wantBackend.environmentVariables[envName] = envValue;
                hasEnvsFromParams = true;
            }
        }
        for (const endpoint of backend.allEndpoints(wantBackend)) {
            endpoint.environmentVariables = Object.assign({}, wantBackend.environmentVariables) || {};
            let resource;
            if (endpoint.platform === "gcfv1") {
                resource = `projects/${endpoint.project}/locations/${endpoint.region}/functions/${endpoint.id}`;
            }
            else if (endpoint.platform === "gcfv2") {
                resource = `projects/${endpoint.project}/locations/${endpoint.region}/services/${endpoint.id}`;
            }
            else {
                (0, functional_1.assertExhaustive)(endpoint.platform);
            }
            endpoint.environmentVariables[exports.EVENTARC_SOURCE_ENV] = resource;
            endpoint.codebase = codebase;
        }
        wantBackends[codebase] = wantBackend;
        if (functionsEnv.hasUserEnvs(userEnvOpt) || hasEnvsFromParams) {
            codebaseUsesEnvs.push(codebase);
        }
        context.codebaseDeployEvents[codebase] = {
            fn_deploy_num_successes: 0,
            fn_deploy_num_failures: 0,
            fn_deploy_num_canceled: 0,
            fn_deploy_num_skipped: 0,
        };
        if (wantBuild.params.length > 0) {
            if (wantBuild.params.every((p) => p.type !== "secret")) {
                context.codebaseDeployEvents[codebase].params = "env_only";
            }
            else {
                context.codebaseDeployEvents[codebase].params = "with_secrets";
            }
        }
        else {
            context.codebaseDeployEvents[codebase].params = "none";
        }
        context.codebaseDeployEvents[codebase].runtime = wantBuild.runtime;
    }
    validate.endpointsAreUnique(wantBackends);
    context.sources = {};
    for (const [codebase, wantBackend] of Object.entries(wantBackends)) {
        const config = (0, projectConfig_1.configForCodebase)(context.config, codebase);
        const sourceDirName = config.source;
        const sourceDir = options.config.path(sourceDirName);
        const source = {};
        if (backend.someEndpoint(wantBackend, () => true)) {
            (0, utils_1.logLabeledBullet)("functions", `preparing ${clc.bold(sourceDirName)} directory for uploading...`);
        }
        if (backend.someEndpoint(wantBackend, (e) => e.platform === "gcfv2")) {
            const packagedSource = await (0, prepareFunctionsUpload_1.prepareFunctionsUpload)(sourceDir, config);
            source.functionsSourceV2 = packagedSource === null || packagedSource === void 0 ? void 0 : packagedSource.pathToSource;
            source.functionsSourceV2Hash = packagedSource === null || packagedSource === void 0 ? void 0 : packagedSource.hash;
        }
        if (backend.someEndpoint(wantBackend, (e) => e.platform === "gcfv1")) {
            const packagedSource = await (0, prepareFunctionsUpload_1.prepareFunctionsUpload)(sourceDir, config, runtimeConfig);
            source.functionsSourceV1 = packagedSource === null || packagedSource === void 0 ? void 0 : packagedSource.pathToSource;
            source.functionsSourceV1Hash = packagedSource === null || packagedSource === void 0 ? void 0 : packagedSource.hash;
        }
        context.sources[codebase] = source;
    }
    payload.functions = {};
    const haveBackends = (0, functionsDeployHelper_1.groupEndpointsByCodebase)(wantBackends, backend.allEndpoints(await backend.existingBackend(context)));
    for (const [codebase, wantBackend] of Object.entries(wantBackends)) {
        const haveBackend = haveBackends[codebase] || backend.empty();
        payload.functions[codebase] = { wantBackend, haveBackend };
    }
    for (const [codebase, { wantBackend, haveBackend }] of Object.entries(payload.functions)) {
        inferDetailsFromExisting(wantBackend, haveBackend, codebaseUsesEnvs.includes(codebase));
        await (0, triggerRegionHelper_1.ensureTriggerRegions)(wantBackend);
        resolveCpuAndConcurrency(wantBackend);
        validate.endpointsAreValid(wantBackend);
        inferBlockingDetails(wantBackend);
    }
    const wantBackend = backend.merge(...Object.values(wantBackends));
    const haveBackend = backend.merge(...Object.values(haveBackends));
    await Promise.all(Object.values(wantBackend.requiredAPIs).map(({ api }) => {
        return ensureApiEnabled.ensure(projectId, api, "functions", false);
    }));
    if (backend.someEndpoint(wantBackend, (e) => e.platform === "gcfv2")) {
        const V2_APIS = [
            "run.googleapis.com",
            "eventarc.googleapis.com",
            "pubsub.googleapis.com",
            "storage.googleapis.com",
        ];
        const enablements = V2_APIS.map((api) => {
            return ensureApiEnabled.ensure(context.projectId, api, "functions");
        });
        await Promise.all(enablements);
        const services = ["pubsub.googleapis.com", "eventarc.googleapis.com"];
        const generateServiceAccounts = services.map((service) => {
            return (0, serviceusage_1.generateServiceIdentity)(projectNumber, service, "functions");
        });
        await Promise.all(generateServiceAccounts);
    }
    const matchingBackend = backend.matchingBackend(wantBackend, (endpoint) => {
        return (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, context.filters);
    });
    await (0, prompts_1.promptForFailurePolicies)(options, matchingBackend, haveBackend);
    await (0, prompts_1.promptForMinInstances)(options, matchingBackend, haveBackend);
    await backend.checkAvailability(context, matchingBackend);
    await (0, checkIam_1.ensureServiceAgentRoles)(projectId, projectNumber, matchingBackend, haveBackend);
    await validate.secretsAreValid(projectId, matchingBackend);
    await ensure.secretAccess(projectId, matchingBackend, haveBackend);
    updateEndpointTargetedStatus(wantBackends, context.filters || []);
    (0, applyHash_1.applyBackendHashToBackends)(wantBackends, context);
}
exports.prepare = prepare;
function inferDetailsFromExisting(want, have, usedDotenv) {
    var _a;
    for (const wantE of backend.allEndpoints(want)) {
        const haveE = (_a = have.endpoints[wantE.region]) === null || _a === void 0 ? void 0 : _a[wantE.id];
        if (!haveE) {
            continue;
        }
        if (!usedDotenv) {
            wantE.environmentVariables = Object.assign(Object.assign({}, haveE.environmentVariables), wantE.environmentVariables);
        }
        if (typeof wantE.availableMemoryMb === "undefined" && haveE.availableMemoryMb) {
            wantE.availableMemoryMb = haveE.availableMemoryMb;
        }
        if (typeof wantE.cpu === "undefined" && haveE.cpu) {
            wantE.cpu = haveE.cpu;
        }
        wantE.securityLevel = haveE.securityLevel ? haveE.securityLevel : "SECURE_ALWAYS";
        maybeCopyTriggerRegion(wantE, haveE);
    }
}
exports.inferDetailsFromExisting = inferDetailsFromExisting;
function maybeCopyTriggerRegion(wantE, haveE) {
    if (!backend.isEventTriggered(wantE) || !backend.isEventTriggered(haveE)) {
        return;
    }
    if (wantE.eventTrigger.region || !haveE.eventTrigger.region) {
        return;
    }
    if (JSON.stringify(haveE.eventTrigger.eventFilters) !==
        JSON.stringify(wantE.eventTrigger.eventFilters)) {
        return;
    }
    wantE.eventTrigger.region = haveE.eventTrigger.region;
}
function updateEndpointTargetedStatus(wantBackends, endpointFilters) {
    for (const wantBackend of Object.values(wantBackends)) {
        for (const endpoint of (0, backend_1.allEndpoints)(wantBackend)) {
            endpoint.targetedByOnly = (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, endpointFilters);
        }
    }
}
exports.updateEndpointTargetedStatus = updateEndpointTargetedStatus;
function inferBlockingDetails(want) {
    var _a, _b, _c;
    const authBlockingEndpoints = backend
        .allEndpoints(want)
        .filter((ep) => backend.isBlockingTriggered(ep) &&
        v1_1.AUTH_BLOCKING_EVENTS.includes(ep.blockingTrigger.eventType));
    if (authBlockingEndpoints.length === 0) {
        return;
    }
    let accessToken = false;
    let idToken = false;
    let refreshToken = false;
    for (const blockingEp of authBlockingEndpoints) {
        accessToken || (accessToken = !!((_a = blockingEp.blockingTrigger.options) === null || _a === void 0 ? void 0 : _a.accessToken));
        idToken || (idToken = !!((_b = blockingEp.blockingTrigger.options) === null || _b === void 0 ? void 0 : _b.idToken));
        refreshToken || (refreshToken = !!((_c = blockingEp.blockingTrigger.options) === null || _c === void 0 ? void 0 : _c.refreshToken));
    }
    for (const blockingEp of authBlockingEndpoints) {
        if (!blockingEp.blockingTrigger.options) {
            blockingEp.blockingTrigger.options = {};
        }
        blockingEp.blockingTrigger.options.accessToken = accessToken;
        blockingEp.blockingTrigger.options.idToken = idToken;
        blockingEp.blockingTrigger.options.refreshToken = refreshToken;
    }
}
exports.inferBlockingDetails = inferBlockingDetails;
function resolveCpuAndConcurrency(want) {
    for (const e of backend.allEndpoints(want)) {
        if (e.platform === "gcfv1") {
            continue;
        }
        if (e.cpu === "gcf_gen1") {
            e.cpu = backend.memoryToGen1Cpu(e.availableMemoryMb || backend.DEFAULT_MEMORY);
        }
        else if (!e.cpu) {
            e.cpu = backend.memoryToGen2Cpu(e.availableMemoryMb || backend.DEFAULT_MEMORY);
        }
        if (!e.concurrency) {
            e.concurrency = e.cpu >= 1 ? backend.DEFAULT_CONCURRENCY : 1;
        }
    }
}
exports.resolveCpuAndConcurrency = resolveCpuAndConcurrency;
async function loadCodebases(config, options, firebaseConfig, runtimeConfig, filters) {
    const codebases = (0, functionsDeployHelper_1.targetCodebases)(config, filters);
    const projectId = (0, projectUtils_1.needProjectId)(options);
    const wantBuilds = {};
    for (const codebase of codebases) {
        const codebaseConfig = (0, projectConfig_1.configForCodebase)(config, codebase);
        const sourceDirName = codebaseConfig.source;
        if (!sourceDirName) {
            throw new error_1.FirebaseError(`No functions code detected at default location (./functions), and no functions source defined in firebase.json`);
        }
        const sourceDir = options.config.path(sourceDirName);
        const delegateContext = {
            projectId,
            sourceDir,
            projectDir: options.config.projectDir,
            runtime: codebaseConfig.runtime || "",
        };
        const runtimeDelegate = await runtimes.getRuntimeDelegate(delegateContext);
        logger_1.logger.debug(`Validating ${runtimeDelegate.name} source`);
        await runtimeDelegate.validate();
        logger_1.logger.debug(`Building ${runtimeDelegate.name} source`);
        await runtimeDelegate.build();
        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
        (0, utils_1.logLabeledBullet)("functions", `Loading and analyzing source code for codebase ${codebase} to determine what to deploy`);
        wantBuilds[codebase] = await runtimeDelegate.discoverBuild(runtimeConfig, Object.assign(Object.assign({}, firebaseEnvs), { GOOGLE_CLOUD_QUOTA_PROJECT: projectId }));
        wantBuilds[codebase].runtime = codebaseConfig.runtime;
    }
    return wantBuilds;
}
exports.loadCodebases = loadCodebases;
