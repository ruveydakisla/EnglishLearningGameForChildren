"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.printTriggerUrls = exports.release = void 0;
const clc = require("colorette");
const logger_1 = require("../../../logger");
const functional_1 = require("../../../functional");
const backend = require("../backend");
const containerCleaner = require("../containerCleaner");
const planner = require("./planner");
const fabricator = require("./fabricator");
const reporter = require("./reporter");
const executor = require("./executor");
const prompts = require("../prompts");
const functionsConfig_1 = require("../../../functionsConfig");
const functionsDeployHelper_1 = require("../functionsDeployHelper");
const error_1 = require("../../../error");
const getProjectNumber_1 = require("../../../getProjectNumber");
async function release(context, options, payload) {
    if (!context.config) {
        return;
    }
    if (!payload.functions) {
        return;
    }
    if (!context.sources) {
        return;
    }
    let plan = {};
    for (const [codebase, { wantBackend, haveBackend }] of Object.entries(payload.functions)) {
        plan = Object.assign(Object.assign({}, plan), planner.createDeploymentPlan({
            codebase,
            wantBackend,
            haveBackend,
            filters: context.filters,
        }));
    }
    const fnsToDelete = Object.values(plan)
        .map((regionalChanges) => regionalChanges.endpointsToDelete)
        .reduce(functional_1.reduceFlat, []);
    const shouldDelete = await prompts.promptForFunctionDeletion(fnsToDelete, options.force, options.nonInteractive);
    if (!shouldDelete) {
        for (const change of Object.values(plan)) {
            change.endpointsToDelete = [];
        }
    }
    const throttlerOptions = {
        retries: 30,
        backoff: 20000,
        concurrency: 40,
        maxBackoff: 100000,
    };
    const fab = new fabricator.Fabricator({
        functionExecutor: new executor.QueueExecutor(throttlerOptions),
        executor: new executor.QueueExecutor(throttlerOptions),
        sources: context.sources,
        appEngineLocation: (0, functionsConfig_1.getAppEngineLocation)(context.firebaseConfig),
        projectNumber: options.projectNumber || (await (0, getProjectNumber_1.getProjectNumber)(context.projectId)),
    });
    const summary = await fab.applyPlan(plan);
    await reporter.logAndTrackDeployStats(summary, context);
    reporter.printErrors(summary);
    const wantBackend = backend.merge(...Object.values(payload.functions).map((p) => p.wantBackend));
    printTriggerUrls(wantBackend);
    const haveEndpoints = backend.allEndpoints(wantBackend);
    const deletedEndpoints = Object.values(plan)
        .map((r) => r.endpointsToDelete)
        .reduce(functional_1.reduceFlat, []);
    await containerCleaner.cleanupBuildImages(haveEndpoints, deletedEndpoints);
    const allErrors = summary.results.filter((r) => r.error).map((r) => r.error);
    if (allErrors.length) {
        const opts = allErrors.length === 1 ? { original: allErrors[0] } : { children: allErrors };
        logger_1.logger.debug("Functions deploy failed.");
        for (const error of allErrors) {
            logger_1.logger.debug(JSON.stringify(error, null, 2));
        }
        throw new error_1.FirebaseError("There was an error deploying functions", Object.assign(Object.assign({}, opts), { exit: 2 }));
    }
}
exports.release = release;
function printTriggerUrls(results) {
    const httpsFunctions = backend.allEndpoints(results).filter(backend.isHttpsTriggered);
    if (httpsFunctions.length === 0) {
        return;
    }
    for (const httpsFunc of httpsFunctions) {
        if (!httpsFunc.uri) {
            logger_1.logger.debug("Not printing URL for HTTPS function. Typically this means it didn't match a filter or we failed deployment");
            continue;
        }
        logger_1.logger.info(clc.bold("Function URL"), `(${(0, functionsDeployHelper_1.getFunctionLabel)(httpsFunc)}):`, httpsFunc.uri);
    }
}
exports.printTriggerUrls = printTriggerUrls;
