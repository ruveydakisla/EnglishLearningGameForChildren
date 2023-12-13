"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const command_1 = require("../command");
const clc = require("colorette");
const fsi = require("../firestore/api");
const types = require("../firestore/api-types");
const logger_1 = require("../logger");
const requirePermissions_1 = require("../requirePermissions");
const types_1 = require("../emulator/types");
const commandUtils_1 = require("../emulator/commandUtils");
exports.command = new command_1.Command("firestore:databases:create <database>")
    .description("Create a database in your Firebase project.")
    .option("--location <locationId>", "Region to create database, for example 'nam5'. Run 'firebase firestore:locations' to get a list of eligible locations. (required)")
    .option("--delete-protection <deleteProtectionState>", "Whether or not to prevent deletion of database, for example 'ENABLED' or 'DISABLED'. Default is 'DISABLED'")
    .option("--point-in-time-recovery <enablement>", "Whether to enable the PITR feature on this database, for example 'ENABLED' or 'DISABLED'. Default is 'DISABLED'")
    .before(requirePermissions_1.requirePermissions, ["datastore.databases.create"])
    .before(commandUtils_1.warnEmulatorNotSupported, types_1.Emulators.FIRESTORE)
    .action(async (database, options) => {
    const api = new fsi.FirestoreApi();
    if (!options.location) {
        logger_1.logger.error("Missing required flag --location. See firebase firestore:databases:create --help for more info.");
        return;
    }
    const type = types.DatabaseType.FIRESTORE_NATIVE;
    if (options.deleteProtection &&
        options.deleteProtection !== types.DatabaseDeleteProtectionStateOption.ENABLED &&
        options.deleteProtection !== types.DatabaseDeleteProtectionStateOption.DISABLED) {
        logger_1.logger.error("Invalid value for flag --delete-protection. See firebase firestore:databases:create --help for more info.");
        return;
    }
    const deleteProtectionState = options.deleteProtection === types.DatabaseDeleteProtectionStateOption.ENABLED
        ? types.DatabaseDeleteProtectionState.ENABLED
        : types.DatabaseDeleteProtectionState.DISABLED;
    if (options.pointInTimeRecovery &&
        options.pointInTimeRecovery !== types.PointInTimeRecoveryEnablementOption.ENABLED &&
        options.pointInTimeRecovery !== types.PointInTimeRecoveryEnablementOption.DISABLED) {
        logger_1.logger.error("Invalid value for flag --point-in-time-recovery. See firebase firestore:databases:create --help for more info.");
        return;
    }
    const pointInTimeRecoveryEnablement = options.pointInTimeRecovery === types.PointInTimeRecoveryEnablementOption.ENABLED
        ? types.PointInTimeRecoveryEnablement.ENABLED
        : types.PointInTimeRecoveryEnablement.DISABLED;
    const databaseResp = await api.createDatabase(options.project, database, options.location, type, deleteProtectionState, pointInTimeRecoveryEnablement);
    if (options.json) {
        logger_1.logger.info(JSON.stringify(databaseResp, undefined, 2));
    }
    else {
        logger_1.logger.info(clc.bold(`Successfully created ${api.prettyDatabaseString(databaseResp)}`));
        logger_1.logger.info("Please be sure to configure Firebase rules in your Firebase config file for\n" +
            "the new database. By default, created databases will have closed rules that\n" +
            "block any incoming third-party traffic.");
    }
    return databaseResp;
});
