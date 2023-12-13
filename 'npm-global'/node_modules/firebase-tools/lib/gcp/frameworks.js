"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createBuild = exports.deleteBackend = exports.listBackends = exports.getBackend = exports.createBackend = exports.API_VERSION = void 0;
const apiv2_1 = require("../apiv2");
const api_1 = require("../api");
exports.API_VERSION = "v1alpha";
const client = new apiv2_1.Client({
    urlPrefix: api_1.frameworksOrigin,
    auth: true,
    apiVersion: exports.API_VERSION,
});
async function createBackend(projectId, location, backendReqBoby, backendId) {
    const res = await client.post(`projects/${projectId}/locations/${location}/backends`, backendReqBoby, { queryParams: { backendId } });
    return res.body;
}
exports.createBackend = createBackend;
async function getBackend(projectId, location, backendId) {
    const name = `projects/${projectId}/locations/${location}/backends/${backendId}`;
    const res = await client.get(name);
    return res.body;
}
exports.getBackend = getBackend;
async function listBackends(projectId, location) {
    const name = `projects/${projectId}/locations/${location}/backends`;
    const res = await client.get(name);
    return res.body;
}
exports.listBackends = listBackends;
async function deleteBackend(projectId, location, backendId) {
    const name = `projects/${projectId}/locations/${location}/backends/${backendId}`;
    const res = await client.delete(name);
    return res.body;
}
exports.deleteBackend = deleteBackend;
async function createBuild(projectId, location, backendId, buildInput) {
    const buildId = buildInput.name;
    const res = await client.post(`projects/${projectId}/locations/${location}/backends/${backendId}/builds`, buildInput, { queryParams: { buildId } });
    return res.body;
}
exports.createBuild = createBuild;
