"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const command_1 = require("../command");
const fsi = require("../firestore/api");
const logger_1 = require("../logger");
const requirePermissions_1 = require("../requirePermissions");
const types_1 = require("../emulator/types");
const commandUtils_1 = require("../emulator/commandUtils");
exports.command = new command_1.Command("firestore:databases:get [database]")
    .description("Get database in your Cloud Firestore project.")
    .before(requirePermissions_1.requirePermissions, ["datastore.databases.get"])
    .before(commandUtils_1.warnEmulatorNotSupported, types_1.Emulators.FIRESTORE)
    .action(async (database, options) => {
    const api = new fsi.FirestoreApi();
    const databaseId = database || "(default)";
    const databaseResp = await api.getDatabase(options.project, databaseId);
    if (options.json) {
        logger_1.logger.info(JSON.stringify(databaseResp, undefined, 2));
    }
    else {
        api.prettyPrintDatabase(databaseResp);
    }
    return databaseResp;
});
