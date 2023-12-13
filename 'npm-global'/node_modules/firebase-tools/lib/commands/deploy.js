"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = exports.TARGET_PERMISSIONS = exports.VALID_DEPLOY_TARGETS = void 0;
const requireDatabaseInstance_1 = require("../requireDatabaseInstance");
const requirePermissions_1 = require("../requirePermissions");
const checkIam_1 = require("../deploy/functions/checkIam");
const checkValidTargetFilters_1 = require("../checkValidTargetFilters");
const command_1 = require("../command");
const deploy_1 = require("../deploy");
const requireConfig_1 = require("../requireConfig");
const filterTargets_1 = require("../filterTargets");
const requireHostingSite_1 = require("../requireHostingSite");
const getDefaultHostingSite_1 = require("../getDefaultHostingSite");
const error_1 = require("../error");
const colorette_1 = require("colorette");
const interactive_1 = require("../hosting/interactive");
const utils_1 = require("../utils");
exports.VALID_DEPLOY_TARGETS = [
    "database",
    "storage",
    "firestore",
    "functions",
    "hosting",
    "remoteconfig",
    "extensions",
];
exports.TARGET_PERMISSIONS = {
    database: ["firebasedatabase.instances.update"],
    hosting: ["firebasehosting.sites.update"],
    functions: [
        "cloudfunctions.functions.list",
        "cloudfunctions.functions.create",
        "cloudfunctions.functions.get",
        "cloudfunctions.functions.update",
        "cloudfunctions.functions.delete",
        "cloudfunctions.operations.get",
    ],
    firestore: [
        "datastore.indexes.list",
        "datastore.indexes.create",
        "datastore.indexes.update",
        "datastore.indexes.delete",
    ],
    storage: [
        "firebaserules.releases.create",
        "firebaserules.rulesets.create",
        "firebaserules.releases.update",
    ],
    remoteconfig: ["cloudconfig.configs.get", "cloudconfig.configs.update"],
};
exports.command = new command_1.Command("deploy")
    .description("deploy code and assets to your Firebase project")
    .withForce("delete Cloud Functions missing from the current working directory and bypass interactive prompts")
    .option("-p, --public <path>", "override the Hosting public directory specified in firebase.json")
    .option("-m, --message <message>", "an optional message describing this deploy")
    .option("--only <targets>", 'only deploy to specified, comma-separated targets (e.g. "hosting,storage"). For functions, ' +
    'can specify filters with colons to scope function deploys to only those functions (e.g. "--only functions:func1,functions:func2"). ' +
    "When filtering based on export groups (the exported module object keys), use dots to specify group names " +
    '(e.g. "--only functions:group1.subgroup1,functions:group2)"')
    .option("--except <targets>", 'deploy to all targets except specified (e.g. "database")')
    .before(requireConfig_1.requireConfig)
    .before((options) => {
    options.filteredTargets = (0, filterTargets_1.filterTargets)(options, exports.VALID_DEPLOY_TARGETS);
    const permissions = options.filteredTargets.reduce((perms, target) => {
        return perms.concat(exports.TARGET_PERMISSIONS[target]);
    }, []);
    return (0, requirePermissions_1.requirePermissions)(options, permissions);
})
    .before((options) => {
    if (options.filteredTargets.includes("functions")) {
        return (0, checkIam_1.checkServiceAccountIam)(options.project);
    }
})
    .before(async (options) => {
    if (options.filteredTargets.includes("database")) {
        await (0, requireDatabaseInstance_1.requireDatabaseInstance)(options);
    }
    if (options.filteredTargets.includes("hosting")) {
        let createSite = false;
        try {
            await (0, requireHostingSite_1.requireHostingSite)(options);
        }
        catch (err) {
            if (err === getDefaultHostingSite_1.errNoDefaultSite) {
                createSite = true;
            }
        }
        if (!createSite) {
            return;
        }
        if (options.nonInteractive) {
            throw new error_1.FirebaseError(`Unable to deploy to Hosting as there is no Hosting site. Use ${(0, colorette_1.bold)("firebase hosting:sites:create")} to create a site.`);
        }
        (0, utils_1.logBullet)("No Hosting site detected.");
        await (0, interactive_1.interactiveCreateHostingSite)("", "", options);
    }
})
    .before(checkValidTargetFilters_1.checkValidTargetFilters)
    .action((options) => {
    return (0, deploy_1.deploy)(options.filteredTargets, options);
});
