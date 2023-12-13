"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.release = void 0;
const queue_1 = require("../../throttler/queue");
const tasks = require("./tasks");
const planner = require("./planner");
const error_1 = require("../../error");
const errors_1 = require("./errors");
const projectUtils_1 = require("../../projectUtils");
const etags_1 = require("../../extensions/etags");
const track_1 = require("../../track");
async function release(context, options, payload) {
    var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o;
    const projectId = (0, projectUtils_1.needProjectId)(options);
    const errorHandler = new errors_1.ErrorHandler();
    const deploymentQueue = new queue_1.default({
        retries: 5,
        concurrency: 5,
        handler: tasks.extensionsDeploymentHandler(errorHandler),
    });
    for (const creation of (_a = payload.instancesToCreate) !== null && _a !== void 0 ? _a : []) {
        const task = tasks.createExtensionInstanceTask(projectId, creation);
        void deploymentQueue.run(task);
    }
    for (const update of (_b = payload.instancesToUpdate) !== null && _b !== void 0 ? _b : []) {
        const task = tasks.updateExtensionInstanceTask(projectId, update);
        void deploymentQueue.run(task);
    }
    for (const update of (_c = payload.instancesToConfigure) !== null && _c !== void 0 ? _c : []) {
        const task = tasks.configureExtensionInstanceTask(projectId, update);
        void deploymentQueue.run(task);
    }
    for (const deletion of (_d = payload.instancesToDelete) !== null && _d !== void 0 ? _d : []) {
        const task = tasks.deleteExtensionInstanceTask(projectId, deletion);
        void deploymentQueue.run(task);
    }
    const deploymentPromise = deploymentQueue.wait();
    deploymentQueue.process();
    deploymentQueue.close();
    await deploymentPromise;
    const duration = context.extensionsStartTime ? Date.now() - context.extensionsStartTime : 1;
    await (0, track_1.trackGA4)("extensions_deploy", {
        extension_instance_created: (_f = (_e = payload.instancesToCreate) === null || _e === void 0 ? void 0 : _e.length) !== null && _f !== void 0 ? _f : 0,
        extension_instance_updated: (_h = (_g = payload.instancesToUpdate) === null || _g === void 0 ? void 0 : _g.length) !== null && _h !== void 0 ? _h : 0,
        extension_instance_configured: (_k = (_j = payload.instancesToConfigure) === null || _j === void 0 ? void 0 : _j.length) !== null && _k !== void 0 ? _k : 0,
        extension_instance_deleted: (_m = (_l = payload.instancesToDelete) === null || _l === void 0 ? void 0 : _l.length) !== null && _m !== void 0 ? _m : 0,
        errors: (_o = errorHandler.errors.length) !== null && _o !== void 0 ? _o : 0,
        interactive: options.nonInteractive ? "false" : "true",
    }, duration);
    const newHave = await planner.have(projectId);
    (0, etags_1.saveEtags)(options.rc, projectId, newHave);
    if (errorHandler.hasErrors()) {
        errorHandler.print();
        throw new error_1.FirebaseError(`Extensions deployment failed.`);
    }
}
exports.release = release;
