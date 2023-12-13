"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ensureServiceAgentRoles = exports.mergeBindings = exports.obtainDefaultComputeServiceAgentBindings = exports.obtainPubSubServiceAgentBindings = exports.getDefaultComputeServiceAgent = exports.checkHttpIam = exports.checkServiceAccountIam = exports.EVENTARC_EVENT_RECEIVER_ROLE = exports.RUN_INVOKER_ROLE = exports.SERVICE_ACCOUNT_TOKEN_CREATOR_ROLE = void 0;
const colorette_1 = require("colorette");
const logger_1 = require("../../logger");
const functionsDeployHelper_1 = require("./functionsDeployHelper");
const error_1 = require("../../error");
const functional_1 = require("../../functional");
const iam = require("../../gcp/iam");
const backend = require("./backend");
const track_1 = require("../../track");
const utils = require("../../utils");
const resourceManager_1 = require("../../gcp/resourceManager");
const services_1 = require("./services");
const PERMISSION = "cloudfunctions.functions.setIamPolicy";
exports.SERVICE_ACCOUNT_TOKEN_CREATOR_ROLE = "roles/iam.serviceAccountTokenCreator";
exports.RUN_INVOKER_ROLE = "roles/run.invoker";
exports.EVENTARC_EVENT_RECEIVER_ROLE = "roles/eventarc.eventReceiver";
async function checkServiceAccountIam(projectId) {
    const saEmail = `${projectId}@appspot.gserviceaccount.com`;
    let passed = false;
    try {
        const iamResult = await iam.testResourceIamPermissions("https://iam.googleapis.com", "v1", `projects/${projectId}/serviceAccounts/${saEmail}`, ["iam.serviceAccounts.actAs"]);
        passed = iamResult.passed;
    }
    catch (err) {
        logger_1.logger.debug("[functions] service account IAM check errored, deploy may fail:", err);
        return;
    }
    if (!passed) {
        throw new error_1.FirebaseError(`Missing permissions required for functions deploy. You must have permission ${(0, colorette_1.bold)("iam.serviceAccounts.ActAs")} on service account ${(0, colorette_1.bold)(saEmail)}.\n\n` +
            `To address this error, ask a project Owner to assign your account the "Service Account User" role from this URL:\n\n` +
            `https://console.cloud.google.com/iam-admin/iam?project=${projectId}`);
    }
}
exports.checkServiceAccountIam = checkServiceAccountIam;
async function checkHttpIam(context, options, payload) {
    if (!payload.functions) {
        return;
    }
    const filters = context.filters || (0, functionsDeployHelper_1.getEndpointFilters)(options);
    const wantBackends = Object.values(payload.functions).map(({ wantBackend }) => wantBackend);
    const httpEndpoints = [...(0, functional_1.flattenArray)(wantBackends.map((b) => backend.allEndpoints(b)))]
        .filter(backend.isHttpsTriggered)
        .filter((f) => (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(f, filters));
    const existing = await backend.existingBackend(context);
    const newHttpsEndpoints = httpEndpoints.filter(backend.missingEndpoint(existing));
    if (newHttpsEndpoints.length === 0) {
        return;
    }
    logger_1.logger.debug("[functions] found", newHttpsEndpoints.length, "new HTTP functions, testing setIamPolicy permission...");
    let passed = true;
    try {
        const iamResult = await iam.testIamPermissions(context.projectId, [PERMISSION]);
        passed = iamResult.passed;
    }
    catch (e) {
        logger_1.logger.debug("[functions] failed http create setIamPolicy permission check. deploy may fail:", e);
        return;
    }
    if (!passed) {
        void (0, track_1.trackGA4)("error", {
            error_type: "Error (User)",
            details: "deploy:functions:http_create_missing_iam",
        });
        throw new error_1.FirebaseError(`Missing required permission on project ${(0, colorette_1.bold)(context.projectId)} to deploy new HTTPS functions. The permission ${(0, colorette_1.bold)(PERMISSION)} is required to deploy the following functions:\n\n- ` +
            newHttpsEndpoints.map((func) => func.id).join("\n- ") +
            `\n\nTo address this error, please ask a project Owner to assign your account the "Cloud Functions Admin" role at the following URL:\n\nhttps://console.cloud.google.com/iam-admin/iam?project=${context.projectId}`);
    }
    logger_1.logger.debug("[functions] found setIamPolicy permission, proceeding with deploy");
}
exports.checkHttpIam = checkHttpIam;
function getPubsubServiceAgent(projectNumber) {
    return `service-${projectNumber}@gcp-sa-pubsub.iam.gserviceaccount.com`;
}
function getDefaultComputeServiceAgent(projectNumber) {
    return `${projectNumber}-compute@developer.gserviceaccount.com`;
}
exports.getDefaultComputeServiceAgent = getDefaultComputeServiceAgent;
function reduceEventsToServices(services, endpoint) {
    const service = (0, services_1.serviceForEndpoint)(endpoint);
    if (service.requiredProjectBindings && !services.find((s) => s.name === service.name)) {
        services.push(service);
    }
    return services;
}
function obtainPubSubServiceAgentBindings(projectNumber) {
    const serviceAccountTokenCreatorBinding = {
        role: exports.SERVICE_ACCOUNT_TOKEN_CREATOR_ROLE,
        members: [`serviceAccount:${getPubsubServiceAgent(projectNumber)}`],
    };
    return [serviceAccountTokenCreatorBinding];
}
exports.obtainPubSubServiceAgentBindings = obtainPubSubServiceAgentBindings;
function obtainDefaultComputeServiceAgentBindings(projectNumber) {
    const defaultComputeServiceAgent = `serviceAccount:${getDefaultComputeServiceAgent(projectNumber)}`;
    const runInvokerBinding = {
        role: exports.RUN_INVOKER_ROLE,
        members: [defaultComputeServiceAgent],
    };
    const eventarcEventReceiverBinding = {
        role: exports.EVENTARC_EVENT_RECEIVER_ROLE,
        members: [defaultComputeServiceAgent],
    };
    return [runInvokerBinding, eventarcEventReceiverBinding];
}
exports.obtainDefaultComputeServiceAgentBindings = obtainDefaultComputeServiceAgentBindings;
function mergeBindings(policy, requiredBindings) {
    let updated = false;
    for (const requiredBinding of requiredBindings) {
        const match = policy.bindings.find((b) => b.role === requiredBinding.role);
        if (!match) {
            updated = true;
            policy.bindings.push(requiredBinding);
            continue;
        }
        for (const requiredMember of requiredBinding.members) {
            if (!match.members.find((m) => m === requiredMember)) {
                updated = true;
                match.members.push(requiredMember);
            }
        }
    }
    return updated;
}
exports.mergeBindings = mergeBindings;
function printManualIamConfig(requiredBindings, projectId) {
    utils.logLabeledBullet("functions", "Failed to verify the project has the correct IAM bindings for a successful deployment.", "warn");
    utils.logLabeledBullet("functions", "You can either re-run `firebase deploy` as a project owner or manually run the following set of `gcloud` commands:", "warn");
    for (const binding of requiredBindings) {
        for (const member of binding.members) {
            utils.logLabeledBullet("functions", `\`gcloud projects add-iam-policy-binding ${projectId} ` +
                `--member=${member} ` +
                `--role=${binding.role}\``, "warn");
        }
    }
}
async function ensureServiceAgentRoles(projectId, projectNumber, want, have) {
    const wantServices = backend.allEndpoints(want).reduce(reduceEventsToServices, []);
    const haveServices = backend.allEndpoints(have).reduce(reduceEventsToServices, []);
    const newServices = wantServices.filter((wantS) => !haveServices.find((haveS) => wantS.name === haveS.name));
    if (newServices.length === 0) {
        return;
    }
    const requiredBindingsPromises = [];
    for (const service of newServices) {
        requiredBindingsPromises.push(service.requiredProjectBindings(projectNumber));
    }
    const nestedRequiredBindings = await Promise.all(requiredBindingsPromises);
    const requiredBindings = [...(0, functional_1.flattenArray)(nestedRequiredBindings)];
    if (haveServices.length === 0) {
        requiredBindings.push(...obtainPubSubServiceAgentBindings(projectNumber));
        requiredBindings.push(...obtainDefaultComputeServiceAgentBindings(projectNumber));
    }
    if (requiredBindings.length === 0) {
        return;
    }
    let policy;
    try {
        policy = await (0, resourceManager_1.getIamPolicy)(projectNumber);
    }
    catch (err) {
        printManualIamConfig(requiredBindings, projectId);
        utils.logLabeledBullet("functions", "Could not verify the necessary IAM configuration for the following newly-integrated services: " +
            `${newServices.map((service) => service.api).join(", ")}` +
            ". Deployment may fail.", "warn");
        return;
    }
    const hasUpdatedBindings = mergeBindings(policy, requiredBindings);
    if (!hasUpdatedBindings) {
        return;
    }
    try {
        await (0, resourceManager_1.setIamPolicy)(projectNumber, policy, "bindings");
    }
    catch (err) {
        printManualIamConfig(requiredBindings, projectId);
        throw new error_1.FirebaseError("We failed to modify the IAM policy for the project. The functions " +
            "deployment requires specific roles to be granted to service agents," +
            " otherwise the deployment will fail.", { original: err });
    }
}
exports.ensureServiceAgentRoles = ensureServiceAgentRoles;
