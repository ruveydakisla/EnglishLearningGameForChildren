"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const command_1 = require("../command");
const fsi = require("../firestore/api");
const logger_1 = require("../logger");
const requirePermissions_1 = require("../requirePermissions");
const types_1 = require("../emulator/types");
const commandUtils_1 = require("../emulator/commandUtils");
exports.command = new command_1.Command("firestore:locations")
    .description("List possible locations for your Cloud Firestore project.")
    .before(requirePermissions_1.requirePermissions, ["datastore.locations.list"])
    .before(commandUtils_1.warnEmulatorNotSupported, types_1.Emulators.FIRESTORE)
    .action(async (options) => {
    const api = new fsi.FirestoreApi();
    const locations = await api.locations(options.project);
    if (options.json) {
        logger_1.logger.info(JSON.stringify(locations, undefined, 2));
    }
    else {
        api.prettyPrintLocations(locations);
    }
    return locations;
});
