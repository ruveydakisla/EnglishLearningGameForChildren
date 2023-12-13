"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateServiceIdentity = void 0;
const colorette_1 = require("colorette");
const api_1 = require("../api");
const apiv2_1 = require("../apiv2");
const error_1 = require("../error");
const utils = require("../utils");
const apiClient = new apiv2_1.Client({
    urlPrefix: api_1.serviceUsageOrigin,
    apiVersion: "v1beta1",
});
async function generateServiceIdentity(projectNumber, service, prefix) {
    utils.logLabeledBullet(prefix, `generating the service identity for ${(0, colorette_1.bold)(service)}...`);
    try {
        return await apiClient.post(`projects/${projectNumber}/services/${service}:generateServiceIdentity`);
    }
    catch (err) {
        throw new error_1.FirebaseError(`Error generating the service identity for ${service}.`, {
            original: err,
        });
    }
}
exports.generateServiceIdentity = generateServiceIdentity;
