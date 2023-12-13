"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const command_1 = require("../command");
const logger_1 = require("../logger");
const prepare_1 = require("../deploy/functions/prepare");
const projectConfig_1 = require("../functions/projectConfig");
const adminSdkConfig_1 = require("../emulator/adminSdkConfig");
const projectUtils_1 = require("../projectUtils");
const error_1 = require("../error");
exports.command = new command_1.Command("internaltesting:functions:discover")
    .description("discover function triggers defined in the current project directory")
    .action(async (options) => {
    const projectId = (0, projectUtils_1.needProjectId)(options);
    const fnConfig = (0, projectConfig_1.normalizeAndValidate)(options.config.src.functions);
    const firebaseConfig = await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(projectId);
    if (!firebaseConfig) {
        throw new error_1.FirebaseError("Admin SDK config unexpectedly undefined - have you run firebase init?");
    }
    const builds = await (0, prepare_1.loadCodebases)(fnConfig, options, firebaseConfig, {
        firebase: firebaseConfig,
    });
    logger_1.logger.info(JSON.stringify(builds, null, 2));
    return builds;
});
