"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.testIamPermissions = exports.testResourceIamPermissions = exports.getRole = exports.listServiceAccountKeys = exports.deleteServiceAccount = exports.createServiceAccountKey = exports.getServiceAccount = exports.createServiceAccount = void 0;
const api_1 = require("../api");
const logger_1 = require("../logger");
const apiv2_1 = require("../apiv2");
const apiClient = new apiv2_1.Client({ urlPrefix: api_1.iamOrigin, apiVersion: "v1" });
async function createServiceAccount(projectId, accountId, description, displayName) {
    const response = await apiClient.post(`/projects/${projectId}/serviceAccounts`, {
        accountId,
        serviceAccount: {
            displayName,
            description,
        },
    }, { skipLog: { resBody: true } });
    return response.body;
}
exports.createServiceAccount = createServiceAccount;
async function getServiceAccount(projectId, serviceAccountName) {
    const response = await apiClient.get(`/projects/${projectId}/serviceAccounts/${serviceAccountName}@${projectId}.iam.gserviceaccount.com`);
    return response.body;
}
exports.getServiceAccount = getServiceAccount;
async function createServiceAccountKey(projectId, serviceAccountName) {
    const response = await apiClient.post(`/projects/${projectId}/serviceAccounts/${serviceAccountName}@${projectId}.iam.gserviceaccount.com/keys`, {
        keyAlgorithm: "KEY_ALG_UNSPECIFIED",
        privateKeyType: "TYPE_GOOGLE_CREDENTIALS_FILE",
    });
    return response.body;
}
exports.createServiceAccountKey = createServiceAccountKey;
async function deleteServiceAccount(projectId, accountEmail) {
    await apiClient.delete(`/projects/${projectId}/serviceAccounts/${accountEmail}`, {
        resolveOnHTTPError: true,
    });
}
exports.deleteServiceAccount = deleteServiceAccount;
async function listServiceAccountKeys(projectId, serviceAccountName) {
    const response = await apiClient.get(`/projects/${projectId}/serviceAccounts/${serviceAccountName}@${projectId}.iam.gserviceaccount.com/keys`);
    return response.body.keys;
}
exports.listServiceAccountKeys = listServiceAccountKeys;
async function getRole(role) {
    const response = await apiClient.get(`/roles/${role}`, {
        retryCodes: [500, 503],
    });
    return response.body;
}
exports.getRole = getRole;
async function testResourceIamPermissions(origin, apiVersion, resourceName, permissions, quotaUser = "") {
    const localClient = new apiv2_1.Client({ urlPrefix: origin, apiVersion });
    if (process.env.FIREBASE_SKIP_INFORMATIONAL_IAM) {
        logger_1.logger.debug(`[iam] skipping informational check of permissions ${JSON.stringify(permissions)} on resource ${resourceName}`);
        return { allowed: Array.from(permissions).sort(), missing: [], passed: true };
    }
    const headers = {};
    if (quotaUser) {
        headers["x-goog-quota-user"] = quotaUser;
    }
    const response = await localClient.post(`/${resourceName}:testIamPermissions`, { permissions }, { headers });
    const allowed = new Set(response.body.permissions || []);
    const missing = new Set(permissions);
    for (const p of allowed) {
        missing.delete(p);
    }
    return {
        allowed: Array.from(allowed).sort(),
        missing: Array.from(missing).sort(),
        passed: missing.size === 0,
    };
}
exports.testResourceIamPermissions = testResourceIamPermissions;
async function testIamPermissions(projectId, permissions) {
    return testResourceIamPermissions(api_1.resourceManagerOrigin, "v1", `projects/${projectId}`, permissions, `projects/${projectId}`);
}
exports.testIamPermissions = testIamPermissions;
