"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deploy = void 0;
const clc = require("colorette");
const logger_1 = require("../logger");
const api_1 = require("../api");
const colorette_1 = require("colorette");
const lodash_1 = require("lodash");
const projectUtils_1 = require("../projectUtils");
const utils_1 = require("../utils");
const error_1 = require("../error");
const track_1 = require("../track");
const lifecycleHooks_1 = require("./lifecycleHooks");
const experiments = require("../experiments");
const HostingTarget = require("./hosting");
const DatabaseTarget = require("./database");
const FirestoreTarget = require("./firestore");
const FunctionsTarget = require("./functions");
const StorageTarget = require("./storage");
const RemoteConfigTarget = require("./remoteconfig");
const ExtensionsTarget = require("./extensions");
const frameworks_1 = require("../frameworks");
const prepare_1 = require("./hosting/prepare");
const github_1 = require("../init/features/hosting/github");
const deploy_1 = require("../commands/deploy");
const requirePermissions_1 = require("../requirePermissions");
const TARGETS = {
    hosting: HostingTarget,
    database: DatabaseTarget,
    firestore: FirestoreTarget,
    functions: FunctionsTarget,
    storage: StorageTarget,
    remoteconfig: RemoteConfigTarget,
    extensions: ExtensionsTarget,
};
const chain = async function (fns, context, options, payload) {
    for (const latest of fns) {
        await latest(context, options, payload);
    }
};
const deploy = async function (targetNames, options, customContext = {}) {
    const projectId = (0, projectUtils_1.needProjectId)(options);
    const payload = {};
    const context = Object.assign({ projectId }, customContext);
    const predeploys = [];
    const prepares = [];
    const deploys = [];
    const releases = [];
    const postdeploys = [];
    const startTime = Date.now();
    if (targetNames.includes("hosting")) {
        const config = options.config.get("hosting");
        if (Array.isArray(config) ? config.some((it) => it.source) : config.source) {
            experiments.assertEnabled("webframeworks", "deploy a web framework from source");
            await (0, frameworks_1.prepareFrameworks)("deploy", targetNames, context, options);
        }
    }
    if (targetNames.includes("hosting") && (0, prepare_1.hasPinnedFunctions)(options)) {
        experiments.assertEnabled("pintags", "deploy a tagged function as a hosting rewrite");
        if (!targetNames.includes("functions")) {
            targetNames.unshift("functions");
            try {
                await (0, requirePermissions_1.requirePermissions)(options, deploy_1.TARGET_PERMISSIONS["functions"]);
            }
            catch (e) {
                if ((0, github_1.isRunningInGithubAction)()) {
                    throw new error_1.FirebaseError("It looks like you are deploying a Hosting site along with Cloud Functions " +
                        "using a GitHub action version that did not include Cloud Functions " +
                        "permissions. Please reinstall the GitHub action with" +
                        clc.bold("firebase init hosting:github"), { original: e });
                }
                else {
                    throw e;
                }
            }
        }
        await (0, prepare_1.addPinnedFunctionsToOnlyString)(context, options);
    }
    for (const targetName of targetNames) {
        const target = TARGETS[targetName];
        if (!target) {
            return Promise.reject(new error_1.FirebaseError(`${(0, colorette_1.bold)(targetName)} is not a valid deploy target`));
        }
        predeploys.push((0, lifecycleHooks_1.lifecycleHooks)(targetName, "predeploy"));
        prepares.push(target.prepare);
        deploys.push(target.deploy);
        releases.push(target.release);
        postdeploys.push((0, lifecycleHooks_1.lifecycleHooks)(targetName, "postdeploy"));
    }
    logger_1.logger.info();
    logger_1.logger.info((0, colorette_1.bold)((0, colorette_1.white)("===") + " Deploying to '" + projectId + "'..."));
    logger_1.logger.info();
    (0, utils_1.logBullet)("deploying " + (0, colorette_1.bold)(targetNames.join(", ")));
    await chain(predeploys, context, options, payload);
    await chain(prepares, context, options, payload);
    await chain(deploys, context, options, payload);
    await chain(releases, context, options, payload);
    await chain(postdeploys, context, options, payload);
    const duration = Date.now() - startTime;
    const analyticsParams = {
        interactive: options.nonInteractive ? "false" : "true",
    };
    Object.keys(TARGETS).reduce((accum, t) => {
        accum[t] = "false";
        return accum;
    }, analyticsParams);
    for (const t of targetNames) {
        analyticsParams[t] = "true";
    }
    await (0, track_1.trackGA4)("product_deploy", analyticsParams, duration);
    logger_1.logger.info();
    (0, utils_1.logSuccess)((0, colorette_1.bold)((0, colorette_1.underline)("Deploy complete!")));
    logger_1.logger.info();
    const deployedHosting = (0, lodash_1.includes)(targetNames, "hosting");
    logger_1.logger.info((0, colorette_1.bold)("Project Console:"), (0, utils_1.consoleUrl)(options.project, "/overview"));
    if (deployedHosting) {
        (0, lodash_1.each)(context.hosting.deploys, (deploy) => {
            logger_1.logger.info((0, colorette_1.bold)("Hosting URL:"), (0, utils_1.addSubdomain)(api_1.hostingOrigin, deploy.config.site));
        });
        const versionNames = context.hosting.deploys.map((deploy) => deploy.version);
        return { hosting: versionNames.length === 1 ? versionNames[0] : versionNames };
    }
    else {
        return { hosting: undefined };
    }
};
exports.deploy = deploy;
