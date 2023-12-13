"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppDistributionClient = exports.UploadReleaseResult = exports.IntegrationState = void 0;
const utils = require("../utils");
const operationPoller = require("../operation-poller");
const error_1 = require("../error");
const apiv2_1 = require("../apiv2");
const api_1 = require("../api");
var IntegrationState;
(function (IntegrationState) {
    IntegrationState["AAB_INTEGRATION_STATE_UNSPECIFIED"] = "AAB_INTEGRATION_STATE_UNSPECIFIED";
    IntegrationState["INTEGRATED"] = "INTEGRATED";
    IntegrationState["PLAY_ACCOUNT_NOT_LINKED"] = "PLAY_ACCOUNT_NOT_LINKED";
    IntegrationState["NO_APP_WITH_GIVEN_BUNDLE_ID_IN_PLAY_ACCOUNT"] = "NO_APP_WITH_GIVEN_BUNDLE_ID_IN_PLAY_ACCOUNT";
    IntegrationState["APP_NOT_PUBLISHED"] = "APP_NOT_PUBLISHED";
    IntegrationState["AAB_STATE_UNAVAILABLE"] = "AAB_STATE_UNAVAILABLE";
    IntegrationState["PLAY_IAS_TERMS_NOT_ACCEPTED"] = "PLAY_IAS_TERMS_NOT_ACCEPTED";
})(IntegrationState = exports.IntegrationState || (exports.IntegrationState = {}));
var UploadReleaseResult;
(function (UploadReleaseResult) {
    UploadReleaseResult["UPLOAD_RELEASE_RESULT_UNSPECIFIED"] = "UPLOAD_RELEASE_RESULT_UNSPECIFIED";
    UploadReleaseResult["RELEASE_CREATED"] = "RELEASE_CREATED";
    UploadReleaseResult["RELEASE_UPDATED"] = "RELEASE_UPDATED";
    UploadReleaseResult["RELEASE_UNMODIFIED"] = "RELEASE_UNMODIFIED";
})(UploadReleaseResult = exports.UploadReleaseResult || (exports.UploadReleaseResult = {}));
class AppDistributionClient {
    constructor() {
        this.appDistroV2Client = new apiv2_1.Client({
            urlPrefix: api_1.appDistributionOrigin,
            apiVersion: "v1",
        });
    }
    async getAabInfo(appName) {
        const apiResponse = await this.appDistroV2Client.get(`/${appName}/aabInfo`);
        return apiResponse.body;
    }
    async uploadRelease(appName, distribution) {
        const client = new apiv2_1.Client({ urlPrefix: api_1.appDistributionOrigin });
        const apiResponse = await client.request({
            method: "POST",
            path: `/upload/v1/${appName}/releases:upload`,
            headers: {
                "X-Goog-Upload-File-Name": encodeURIComponent(distribution.getFileName()),
                "X-Goog-Upload-Protocol": "raw",
                "Content-Type": "application/octet-stream",
            },
            responseType: "json",
            body: distribution.readStream(),
        });
        return apiResponse.body.name;
    }
    async pollUploadStatus(operationName) {
        return operationPoller.pollOperation({
            pollerName: "App Distribution Upload Poller",
            apiOrigin: api_1.appDistributionOrigin,
            apiVersion: "v1",
            operationResourceName: operationName,
            masterTimeout: 5 * 60 * 1000,
            backoff: 1000,
            maxBackoff: 10 * 1000,
        });
    }
    async updateReleaseNotes(releaseName, releaseNotes) {
        if (!releaseNotes) {
            utils.logWarning("no release notes specified, skipping");
            return;
        }
        utils.logBullet("updating release notes...");
        const data = {
            name: releaseName,
            releaseNotes: {
                text: releaseNotes,
            },
        };
        const queryParams = { updateMask: "release_notes.text" };
        try {
            await this.appDistroV2Client.patch(`/${releaseName}`, data, { queryParams });
        }
        catch (err) {
            throw new error_1.FirebaseError(`failed to update release notes with ${err === null || err === void 0 ? void 0 : err.message}`);
        }
        utils.logSuccess("added release notes successfully");
    }
    async distribute(releaseName, testerEmails = [], groupAliases = []) {
        var _a, _b, _c;
        if (testerEmails.length === 0 && groupAliases.length === 0) {
            utils.logWarning("no testers or groups specified, skipping");
            return;
        }
        utils.logBullet("distributing to testers/groups...");
        const data = {
            testerEmails,
            groupAliases,
        };
        try {
            await this.appDistroV2Client.post(`/${releaseName}:distribute`, data);
        }
        catch (err) {
            let errorMessage = err.message;
            const errorStatus = (_c = (_b = (_a = err === null || err === void 0 ? void 0 : err.context) === null || _a === void 0 ? void 0 : _a.body) === null || _b === void 0 ? void 0 : _b.error) === null || _c === void 0 ? void 0 : _c.status;
            if (errorStatus === "FAILED_PRECONDITION") {
                errorMessage = "invalid testers";
            }
            else if (errorStatus === "INVALID_ARGUMENT") {
                errorMessage = "invalid groups";
            }
            throw new error_1.FirebaseError(`failed to distribute to testers/groups: ${errorMessage}`, {
                exit: 1,
            });
        }
        utils.logSuccess("distributed to testers/groups successfully");
    }
    async addTesters(projectName, emails) {
        try {
            await this.appDistroV2Client.request({
                method: "POST",
                path: `${projectName}/testers:batchAdd`,
                body: { emails: emails },
            });
        }
        catch (err) {
            throw new error_1.FirebaseError(`Failed to add testers ${err}`);
        }
        utils.logSuccess(`Testers created successfully`);
    }
    async removeTesters(projectName, emails) {
        let apiResponse;
        try {
            apiResponse = await this.appDistroV2Client.request({
                method: "POST",
                path: `${projectName}/testers:batchRemove`,
                body: { emails: emails },
            });
        }
        catch (err) {
            throw new error_1.FirebaseError(`Failed to remove testers ${err}`);
        }
        return apiResponse.body;
    }
    async createGroup(projectName, displayName, alias) {
        let apiResponse;
        try {
            apiResponse = await this.appDistroV2Client.request({
                method: "POST",
                path: alias === undefined ? `${projectName}/groups` : `${projectName}/groups?groupId=${alias}`,
                body: { displayName: displayName },
            });
        }
        catch (err) {
            throw new error_1.FirebaseError(`Failed to create group ${err}`);
        }
        return apiResponse.body;
    }
    async deleteGroup(groupName) {
        try {
            await this.appDistroV2Client.request({
                method: "DELETE",
                path: groupName,
            });
        }
        catch (err) {
            throw new error_1.FirebaseError(`Failed to delete group ${err}`);
        }
        utils.logSuccess(`Group deleted successfully`);
    }
    async addTestersToGroup(groupName, emails) {
        try {
            await this.appDistroV2Client.request({
                method: "POST",
                path: `${groupName}:batchJoin`,
                body: { emails: emails },
            });
        }
        catch (err) {
            throw new error_1.FirebaseError(`Failed to add testers to group ${err}`);
        }
        utils.logSuccess(`Testers added to group successfully`);
    }
    async removeTestersFromGroup(groupName, emails) {
        try {
            await this.appDistroV2Client.request({
                method: "POST",
                path: `${groupName}:batchLeave`,
                body: { emails: emails },
            });
        }
        catch (err) {
            throw new error_1.FirebaseError(`Failed to remove testers from group ${err}`);
        }
        utils.logSuccess(`Testers removed from group successfully`);
    }
}
exports.AppDistributionClient = AppDistributionClient;
