"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteDocuments = exports.deleteDocument = exports.listCollectionIds = exports.getDatabase = void 0;
const api_1 = require("../api");
const apiv2_1 = require("../apiv2");
const logger_1 = require("../logger");
const apiClient = new apiv2_1.Client({
    auth: true,
    apiVersion: "v1",
    urlPrefix: api_1.firestoreOrigin,
});
async function getDatabase(project, database) {
    const url = `projects/${project}/databases/${database}`;
    try {
        const resp = await apiClient.get(url);
        return resp.body;
    }
    catch (err) {
        logger_1.logger.info(`There was an error retrieving the Firestore database. Currently, the database id is set to ${database}, make sure it exists.`);
        throw err;
    }
}
exports.getDatabase = getDatabase;
function listCollectionIds(project) {
    const url = "projects/" + project + "/databases/(default)/documents:listCollectionIds";
    const data = {
        pageSize: 2147483647,
    };
    return apiClient.post(url, data).then((res) => {
        return res.body.collectionIds || [];
    });
}
exports.listCollectionIds = listCollectionIds;
async function deleteDocument(doc) {
    return apiClient.delete(doc.name);
}
exports.deleteDocument = deleteDocument;
async function deleteDocuments(project, docs) {
    const url = "projects/" + project + "/databases/(default)/documents:commit";
    const writes = docs.map((doc) => {
        return { delete: doc.name };
    });
    const data = { writes };
    const res = await apiClient.post(url, data);
    return res.body.writeResults.length;
}
exports.deleteDocuments = deleteDocuments;
