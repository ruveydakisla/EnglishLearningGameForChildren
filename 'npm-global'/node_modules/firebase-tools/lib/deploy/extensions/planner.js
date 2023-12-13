"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.resolveVersion = exports.want = exports.have = exports.getExtensionSpec = exports.getExtension = exports.getExtensionVersion = void 0;
const semver = require("semver");
const extensionsApi = require("../../extensions/extensionsApi");
const refs = require("../../extensions/refs");
const error_1 = require("../../error");
const extensionsHelper_1 = require("../../extensions/extensionsHelper");
const logger_1 = require("../../logger");
const manifest_1 = require("../../extensions/manifest");
const paramHelper_1 = require("../../extensions/paramHelper");
const specHelper_1 = require("../../extensions/emulator/specHelper");
const functional_1 = require("../../functional");
async function getExtensionVersion(i) {
    if (!i.extensionVersion) {
        if (!i.ref) {
            throw new error_1.FirebaseError(`Can't get ExtensionVersion for ${i.instanceId} because it has no ref`);
        }
        i.extensionVersion = await extensionsApi.getExtensionVersion(refs.toExtensionVersionRef(i.ref));
    }
    return i.extensionVersion;
}
exports.getExtensionVersion = getExtensionVersion;
async function getExtension(i) {
    if (!i.ref) {
        throw new error_1.FirebaseError(`Can't get Extension for ${i.instanceId} because it has no ref`);
    }
    if (!i.extension) {
        i.extension = await extensionsApi.getExtension(refs.toExtensionRef(i.ref));
    }
    return i.extension;
}
exports.getExtension = getExtension;
async function getExtensionSpec(i) {
    if (!i.extensionSpec) {
        if (i.ref) {
            const extensionVersion = await getExtensionVersion(i);
            i.extensionSpec = extensionVersion.spec;
        }
        else if (i.localPath) {
            i.extensionSpec = await (0, specHelper_1.readExtensionYaml)(i.localPath);
            i.extensionSpec.postinstallContent = await (0, specHelper_1.readPostinstall)(i.localPath);
        }
        else {
            throw new error_1.FirebaseError("InstanceSpec had no ref or localPath, unable to get extensionSpec");
        }
    }
    return i.extensionSpec;
}
exports.getExtensionSpec = getExtensionSpec;
async function have(projectId) {
    const instances = await extensionsApi.listInstances(projectId);
    return instances.map((i) => {
        var _a;
        const dep = {
            instanceId: i.name.split("/").pop(),
            params: i.config.params,
            systemParams: (_a = i.config.systemParams) !== null && _a !== void 0 ? _a : {},
            allowedEventTypes: i.config.allowedEventTypes,
            eventarcChannel: i.config.eventarcChannel,
            etag: i.etag,
        };
        if (i.config.extensionRef) {
            const ref = refs.parse(i.config.extensionRef);
            dep.ref = ref;
            dep.ref.version = i.config.extensionVersion;
        }
        return dep;
    });
}
exports.have = have;
async function want(args) {
    const instanceSpecs = [];
    const errors = [];
    for (const e of Object.entries(args.extensions)) {
        try {
            const instanceId = e[0];
            const rawParams = (0, manifest_1.readInstanceParam)({
                projectDir: args.projectDir,
                instanceId,
                projectId: args.projectId,
                projectNumber: args.projectNumber,
                aliases: args.aliases,
                checkLocal: args.emulatorMode,
            });
            const autoPopulatedParams = await (0, extensionsHelper_1.getFirebaseProjectParams)(args.projectId, args.emulatorMode);
            const subbedParams = (0, extensionsHelper_1.substituteParams)(rawParams, autoPopulatedParams);
            const [systemParams, params] = (0, functional_1.partitionRecord)(subbedParams, paramHelper_1.isSystemParam);
            const allowedEventTypes = params.ALLOWED_EVENT_TYPES !== undefined
                ? params.ALLOWED_EVENT_TYPES.split(",").filter((e) => e !== "")
                : undefined;
            const eventarcChannel = params.EVENTARC_CHANNEL;
            delete params["EVENTARC_CHANNEL"];
            delete params["ALLOWED_EVENT_TYPES"];
            if ((0, extensionsHelper_1.isLocalPath)(e[1])) {
                instanceSpecs.push({
                    instanceId,
                    localPath: e[1],
                    params,
                    systemParams,
                    allowedEventTypes: allowedEventTypes,
                    eventarcChannel: eventarcChannel,
                });
            }
            else {
                const ref = refs.parse(e[1]);
                ref.version = await resolveVersion(ref);
                instanceSpecs.push({
                    instanceId,
                    ref,
                    params,
                    systemParams,
                    allowedEventTypes: allowedEventTypes,
                    eventarcChannel: eventarcChannel,
                });
            }
        }
        catch (err) {
            logger_1.logger.debug(`Got error reading extensions entry ${e}: ${err}`);
            errors.push(err);
        }
    }
    if (errors.length) {
        const messages = errors.map((err) => `- ${err.message}`).join("\n");
        throw new error_1.FirebaseError(`Errors while reading 'extensions' in 'firebase.json'\n${messages}`);
    }
    return instanceSpecs;
}
exports.want = want;
async function resolveVersion(ref, extension) {
    const extensionRef = refs.toExtensionRef(ref);
    if (!ref.version && (extension === null || extension === void 0 ? void 0 : extension.latestApprovedVersion)) {
        return extension.latestApprovedVersion;
    }
    if (ref.version === "latest-approved") {
        if (!(extension === null || extension === void 0 ? void 0 : extension.latestApprovedVersion)) {
            throw new error_1.FirebaseError(`${extensionRef} has not been published to Extensions Hub (https://extensions.dev). To install it, you must specify the version you want to install.`);
        }
        return extension.latestApprovedVersion;
    }
    if (!ref.version || ref.version === "latest") {
        if (!(extension === null || extension === void 0 ? void 0 : extension.latestVersion)) {
            throw new error_1.FirebaseError(`${extensionRef} has no stable non-deprecated versions. If you wish to install a prerelease version, you must specify the version you want to install.`);
        }
        return extension.latestVersion;
    }
    const versions = await extensionsApi.listExtensionVersions(extensionRef, undefined, true);
    if (versions.length === 0) {
        throw new error_1.FirebaseError(`No versions found for ${extensionRef}`);
    }
    const maxSatisfying = semver.maxSatisfying(versions.map((ev) => ev.spec.version), ref.version);
    if (!maxSatisfying) {
        throw new error_1.FirebaseError(`No version of ${extensionRef} matches requested version ${ref.version}`);
    }
    return maxSatisfying;
}
exports.resolveVersion = resolveVersion;
