"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const rulesDeploy_1 = require("../../rulesDeploy");
const logger_1 = require("../../logger");
async function default_1(context, options) {
    var _a, _b;
    const rulesDeploy = (_a = context === null || context === void 0 ? void 0 : context.firestore) === null || _a === void 0 ? void 0 : _a.rulesDeploy;
    if (!context.firestoreRules || !rulesDeploy) {
        return;
    }
    const rulesContext = (_b = context === null || context === void 0 ? void 0 : context.firestore) === null || _b === void 0 ? void 0 : _b.rules;
    await Promise.all(rulesContext.map(async (ruleContext) => {
        const databaseId = ruleContext.databaseId;
        const rulesFile = ruleContext.rulesFile;
        if (!rulesFile) {
            logger_1.logger.error(`Invalid firestore config for ${databaseId} database: ${JSON.stringify(options.config.src.firestore)}`);
            return;
        }
        return rulesDeploy.release(rulesFile, rulesDeploy_1.RulesetServiceType.CLOUD_FIRESTORE, databaseId);
    }));
}
exports.default = default_1;
