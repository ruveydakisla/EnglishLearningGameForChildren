"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.prepare = void 0;
const planner = require("./planner");
const deploymentSummary = require("./deploymentSummary");
const prompt = require("../../prompt");
const refs = require("../../extensions/refs");
const projectUtils_1 = require("../../projectUtils");
const logger_1 = require("../../logger");
const error_1 = require("../../error");
const requirePermissions_1 = require("../../requirePermissions");
const extensionsHelper_1 = require("../../extensions/extensionsHelper");
const secretsUtils_1 = require("../../extensions/secretsUtils");
const secrets_1 = require("./secrets");
const warnings_1 = require("../../extensions/warnings");
const etags_1 = require("../../extensions/etags");
const v2FunctionHelper_1 = require("./v2FunctionHelper");
const tos_1 = require("../../extensions/tos");
async function prepare(context, options, payload) {
    var _a, _b;
    context.extensionsStartTime = Date.now();
    const projectId = (0, projectUtils_1.needProjectId)(options);
    const projectNumber = await (0, projectUtils_1.needProjectNumber)(options);
    const aliases = (0, projectUtils_1.getAliases)(options, projectId);
    await (0, extensionsHelper_1.ensureExtensionsApiEnabled)(options);
    await (0, requirePermissions_1.requirePermissions)(options, ["firebaseextensions.instances.list"]);
    context.have = await planner.have(projectId);
    context.want = await planner.want({
        projectId,
        projectNumber,
        aliases,
        projectDir: options.config.projectDir,
        extensions: options.config.get("extensions"),
    });
    const etagsChanged = (0, etags_1.detectEtagChanges)(options.rc, projectId, context.have);
    if (etagsChanged.length) {
        (0, warnings_1.outOfBandChangesWarning)(etagsChanged);
        if (!(await prompt.confirm({
            message: `Do you wish to continue deploying these extension instances?`,
            default: false,
            nonInteractive: options.nonInteractive,
            force: options.force,
        }))) {
            throw new error_1.FirebaseError("Deployment cancelled");
        }
    }
    const usingSecrets = await Promise.all((_a = context.want) === null || _a === void 0 ? void 0 : _a.map(secrets_1.checkSpecForSecrets));
    if (usingSecrets.some((i) => i)) {
        await (0, secretsUtils_1.ensureSecretManagerApiEnabled)(options);
    }
    const usingV2Functions = await Promise.all((_b = context.want) === null || _b === void 0 ? void 0 : _b.map(v2FunctionHelper_1.checkSpecForV2Functions));
    if (usingV2Functions) {
        await (0, v2FunctionHelper_1.ensureNecessaryV2ApisAndRoles)(options);
    }
    payload.instancesToCreate = context.want.filter((i) => { var _a; return !((_a = context.have) === null || _a === void 0 ? void 0 : _a.some(matchesInstanceId(i))); });
    payload.instancesToConfigure = context.want.filter((i) => { var _a; return (_a = context.have) === null || _a === void 0 ? void 0 : _a.some(isConfigure(i)); });
    payload.instancesToUpdate = context.want.filter((i) => { var _a; return (_a = context.have) === null || _a === void 0 ? void 0 : _a.some(isUpdate(i)); });
    payload.instancesToDelete = context.have.filter((i) => { var _a; return !((_a = context.want) === null || _a === void 0 ? void 0 : _a.some(matchesInstanceId(i))); });
    if (await (0, warnings_1.displayWarningsForDeploy)(payload.instancesToCreate)) {
        if (!(await prompt.confirm({
            message: `Do you wish to continue deploying these extension instances?`,
            default: true,
            nonInteractive: options.nonInteractive,
            force: options.force,
        }))) {
            throw new error_1.FirebaseError("Deployment cancelled");
        }
    }
    const permissionsNeeded = [];
    if (payload.instancesToCreate.length) {
        permissionsNeeded.push("firebaseextensions.instances.create");
        logger_1.logger.info(deploymentSummary.createsSummary(payload.instancesToCreate));
    }
    if (payload.instancesToUpdate.length) {
        permissionsNeeded.push("firebaseextensions.instances.update");
        logger_1.logger.info(deploymentSummary.updatesSummary(payload.instancesToUpdate, context.have));
    }
    if (payload.instancesToConfigure.length) {
        permissionsNeeded.push("firebaseextensions.instances.update");
        logger_1.logger.info(deploymentSummary.configuresSummary(payload.instancesToConfigure));
    }
    if (payload.instancesToDelete.length) {
        logger_1.logger.info(deploymentSummary.deletesSummary(payload.instancesToDelete));
        if (!(await prompt.confirm({
            message: `Would you like to delete ${payload.instancesToDelete
                .map((i) => i.instanceId)
                .join(", ")}?`,
            default: false,
            nonInteractive: options.nonInteractive,
            force: options.force,
        }))) {
            payload.instancesToDelete = [];
        }
        else {
            permissionsNeeded.push("firebaseextensions.instances.delete");
        }
    }
    await (0, requirePermissions_1.requirePermissions)(options, permissionsNeeded);
    await (0, tos_1.acceptLatestAppDeveloperTOS)(options, projectId, context.want.map((i) => i.instanceId));
}
exports.prepare = prepare;
const matchesInstanceId = (dep) => (test) => {
    return dep.instanceId === test.instanceId;
};
const isUpdate = (dep) => (test) => {
    return dep.instanceId === test.instanceId && !refs.equal(dep.ref, test.ref);
};
const isConfigure = (dep) => (test) => {
    return dep.instanceId === test.instanceId && refs.equal(dep.ref, test.ref);
};
