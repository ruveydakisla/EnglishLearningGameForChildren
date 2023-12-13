"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const backend = require("../deploy/functions/backend");
const secrets = require("../functions/secrets");
const command_1 = require("../command");
const projectUtils_1 = require("../projectUtils");
const requirePermissions_1 = require("../requirePermissions");
const deploymentTool_1 = require("../deploymentTool");
const utils_1 = require("../utils");
const prompt_1 = require("../prompt");
const secretManager_1 = require("../gcp/secretManager");
const requireAuth_1 = require("../requireAuth");
exports.command = new command_1.Command("functions:secrets:prune")
    .withForce("Destroys unused secrets without prompt")
    .description("Destroys unused secrets")
    .before(requireAuth_1.requireAuth)
    .before(secrets.ensureApi)
    .before(requirePermissions_1.requirePermissions, [
    "cloudfunctions.functions.list",
    "secretmanager.secrets.list",
    "secretmanager.versions.list",
    "secretmanager.versions.destroy",
])
    .action(async (options) => {
    const projectNumber = await (0, projectUtils_1.needProjectNumber)(options);
    const projectId = (0, projectUtils_1.needProjectId)(options);
    (0, utils_1.logBullet)("Loading secrets...");
    const haveBackend = await backend.existingBackend({ projectId });
    const haveEndpoints = backend
        .allEndpoints(haveBackend)
        .filter((e) => (0, deploymentTool_1.isFirebaseManaged)(e.labels || []));
    const pruned = await secrets.pruneSecrets({ projectNumber, projectId }, haveEndpoints);
    if (pruned.length === 0) {
        (0, utils_1.logBullet)("All secrets are in use. Nothing to prune today.");
        return;
    }
    (0, utils_1.logBullet)(`Found ${pruned.length} unused active secret versions:\n\t` +
        pruned.map((sv) => `${sv.secret}@${sv.version}`).join("\n\t"));
    if (!options.force) {
        const confirm = await (0, prompt_1.promptOnce)({
            name: "destroy",
            type: "confirm",
            default: true,
            message: `Do you want to destroy unused secret versions?`,
        }, options);
        if (!confirm) {
            (0, utils_1.logBullet)("Run the following commands to destroy each unused secret version:\n\t" +
                pruned
                    .map((sv) => `firebase functions:secrets:destroy ${sv.secret}@${sv.version}`)
                    .join("\n\t"));
            return;
        }
    }
    await Promise.all(pruned.map((sv) => (0, secretManager_1.destroySecretVersion)(projectId, sv.secret, sv.version)));
    (0, utils_1.logSuccess)("Destroyed all unused secrets!");
});
