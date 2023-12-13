"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const clc = require("colorette");
const api_1 = require("../../firestore/api");
const logger_1 = require("../../logger");
const utils = require("../../utils");
const rulesDeploy_1 = require("../../rulesDeploy");
async function deployRules(context) {
    var _a;
    const rulesDeploy = (_a = context === null || context === void 0 ? void 0 : context.firestore) === null || _a === void 0 ? void 0 : _a.rulesDeploy;
    if (!context.firestoreRules || !rulesDeploy) {
        return;
    }
    await rulesDeploy.createRulesets(rulesDeploy_1.RulesetServiceType.CLOUD_FIRESTORE);
}
async function deployIndexes(context, options) {
    var _a;
    if (!context.firestoreIndexes) {
        return;
    }
    const indexesContext = (_a = context === null || context === void 0 ? void 0 : context.firestore) === null || _a === void 0 ? void 0 : _a.indexes;
    utils.logBullet(clc.bold(clc.cyan("firestore: ")) + "deploying indexes...");
    const firestoreIndexes = new api_1.FirestoreApi();
    await Promise.all(indexesContext.map(async (indexContext) => {
        const { databaseId, indexesFileName, indexesRawSpec } = indexContext;
        if (!indexesRawSpec) {
            logger_1.logger.debug(`No Firestore indexes present for ${databaseId} database.`);
            return;
        }
        const indexes = indexesRawSpec.indexes;
        if (!indexes) {
            logger_1.logger.error(`${databaseId} database index file must contain "indexes" property.`);
            return;
        }
        const fieldOverrides = indexesRawSpec.fieldOverrides || [];
        await firestoreIndexes.deploy(options, indexes, fieldOverrides, databaseId).then(() => {
            utils.logSuccess(`${clc.bold(clc.green("firestore:"))} deployed indexes in ${clc.bold(indexesFileName)} successfully for ${databaseId} database`);
        });
    }));
}
async function default_1(context, options) {
    await Promise.all([deployRules(context), deployIndexes(context, options)]);
}
exports.default = default_1;
