"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const command_1 = require("../command");
const clc = require("colorette");
const fsi = require("../firestore/api");
const prompt_1 = require("../prompt");
const logger_1 = require("../logger");
const requirePermissions_1 = require("../requirePermissions");
const types_1 = require("../emulator/types");
const commandUtils_1 = require("../emulator/commandUtils");
const error_1 = require("../error");
exports.command = new command_1.Command("firestore:databases:delete <database>")
    .description("Delete a database in your Cloud Firestore project. Database delete protection state must be disabled. To do so, use the update command: firebase firestore:databases:update <database> --delete-protection DISABLED")
    .option("--force", "Attempt to delete database without prompting for confirmation.")
    .before(requirePermissions_1.requirePermissions, ["datastore.databases.delete"])
    .before(commandUtils_1.warnEmulatorNotSupported, types_1.Emulators.FIRESTORE)
    .action(async (database, options) => {
    const api = new fsi.FirestoreApi();
    if (!options.force) {
        const confirmMessage = `You are about to delete projects/${options.project}/databases/${database}. Do you wish to continue?`;
        const consent = await (0, prompt_1.promptOnce)({
            type: "confirm",
            message: confirmMessage,
            default: false,
        });
        if (!consent) {
            throw new error_1.FirebaseError("Delete database canceled.");
        }
    }
    const databaseResp = await api.deleteDatabase(options.project, database);
    if (options.json) {
        logger_1.logger.info(JSON.stringify(databaseResp, undefined, 2));
    }
    else {
        logger_1.logger.info(clc.bold(`Successfully deleted ${api.prettyDatabaseString(databaseResp)}`));
    }
    return databaseResp;
});
