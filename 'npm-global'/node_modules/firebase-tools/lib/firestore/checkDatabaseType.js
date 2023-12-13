"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkDatabaseType = void 0;
const api_1 = require("../api");
const apiv2_1 = require("../apiv2");
const logger_1 = require("../logger");
async function checkDatabaseType(projectId) {
    try {
        const client = new apiv2_1.Client({ urlPrefix: api_1.firestoreOrigin, apiVersion: "v1" });
        const resp = await client.get(`/projects/${projectId}/databases/(default)`);
        return resp.body.type;
    }
    catch (err) {
        logger_1.logger.debug("error getting database type", err);
        return undefined;
    }
}
exports.checkDatabaseType = checkDatabaseType;
