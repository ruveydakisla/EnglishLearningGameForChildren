"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const command_1 = require("../command");
const clc = require("colorette");
const fsi = require("../firestore/api");
const logger_1 = require("../logger");
const requirePermissions_1 = require("../requirePermissions");
const types_1 = require("../emulator/types");
const commandUtils_1 = require("../emulator/commandUtils");
exports.command = new command_1.Command("firestore:indexes")
    .description("List indexes in your project's Cloud Firestore database.")
    .option("--pretty", "Pretty print. When not specified the indexes are printed in the " +
    "JSON specification format.")
    .option("--database <databaseId>", "Database ID of the firestore database from which to list indexes. (default) if none provided.")
    .before(requirePermissions_1.requirePermissions, ["datastore.indexes.list"])
    .before(commandUtils_1.warnEmulatorNotSupported, types_1.Emulators.FIRESTORE)
    .action(async (options) => {
    var _a;
    const indexApi = new fsi.FirestoreApi();
    const databaseId = (_a = options.database) !== null && _a !== void 0 ? _a : "(default)";
    const indexes = await indexApi.listIndexes(options.project, databaseId);
    const fieldOverrides = await indexApi.listFieldOverrides(options.project, databaseId);
    const indexSpec = indexApi.makeIndexSpec(indexes, fieldOverrides);
    if (options.pretty) {
        logger_1.logger.info(clc.bold(clc.white("Compound Indexes")));
        indexApi.prettyPrintIndexes(indexes);
        if (fieldOverrides) {
            logger_1.logger.info();
            logger_1.logger.info(clc.bold(clc.white("Field Overrides")));
            indexApi.printFieldOverrides(fieldOverrides);
        }
    }
    else {
        logger_1.logger.info(JSON.stringify(indexSpec, undefined, 2));
    }
    return indexSpec;
});
