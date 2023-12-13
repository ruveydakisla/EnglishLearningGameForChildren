"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.githubApiOrigin = exports.githubOrigin = exports.frameworksOrigin = exports.serviceUsageOrigin = exports.cloudRunApiOrigin = exports.hostingApiOrigin = exports.firebaseStorageOrigin = exports.storageOrigin = exports.runtimeconfigOrigin = exports.rulesOrigin = exports.resourceManagerOrigin = exports.remoteConfigApiOrigin = exports.rtdbMetadataOrigin = exports.rtdbManagementOrigin = exports.realtimeOrigin = exports.extensionsTOSOrigin = exports.extensionsPublisherOrigin = exports.extensionsOrigin = exports.iamOrigin = exports.identityOrigin = exports.hostingOrigin = exports.googleOrigin = exports.pubsubOrigin = exports.cloudTasksOrigin = exports.cloudschedulerOrigin = exports.cloudbuildOrigin = exports.functionsDefaultRegion = exports.runOrigin = exports.functionsV2Origin = exports.functionsOrigin = exports.firestoreOrigin = exports.firestoreOriginOrEmulator = exports.firedataOrigin = exports.firebaseExtensionsRegistryOrigin = exports.firebaseApiOrigin = exports.eventarcOrigin = exports.dynamicLinksKey = exports.dynamicLinksOrigin = exports.deployOrigin = exports.consoleOrigin = exports.authOrigin = exports.appDistributionOrigin = exports.artifactRegistryDomain = exports.containerRegistryDomain = exports.cloudMonitoringOrigin = exports.cloudloggingOrigin = exports.cloudbillingOrigin = exports.clientSecret = exports.clientId = exports.authProxyOrigin = void 0;
exports.setScopes = exports.getScopes = exports.githubClientSecret = exports.githubClientId = exports.secretManagerOrigin = void 0;
const constants_1 = require("./emulator/constants");
const logger_1 = require("./logger");
const scopes = require("./scopes");
const utils = require("./utils");
let commandScopes = new Set();
exports.authProxyOrigin = utils.envOverride("FIREBASE_AUTHPROXY_URL", "https://auth.firebase.tools");
exports.clientId = utils.envOverride("FIREBASE_CLIENT_ID", "563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com");
exports.clientSecret = utils.envOverride("FIREBASE_CLIENT_SECRET", "j9iVZfS8kkCEFUPaAeJV0sAi");
exports.cloudbillingOrigin = utils.envOverride("FIREBASE_CLOUDBILLING_URL", "https://cloudbilling.googleapis.com");
exports.cloudloggingOrigin = utils.envOverride("FIREBASE_CLOUDLOGGING_URL", "https://logging.googleapis.com");
exports.cloudMonitoringOrigin = utils.envOverride("CLOUD_MONITORING_URL", "https://monitoring.googleapis.com");
exports.containerRegistryDomain = utils.envOverride("CONTAINER_REGISTRY_DOMAIN", "gcr.io");
exports.artifactRegistryDomain = utils.envOverride("ARTIFACT_REGISTRY_DOMAIN", "https://artifactregistry.googleapis.com");
exports.appDistributionOrigin = utils.envOverride("FIREBASE_APP_DISTRIBUTION_URL", "https://firebaseappdistribution.googleapis.com");
exports.authOrigin = utils.envOverride("FIREBASE_AUTH_URL", "https://accounts.google.com");
exports.consoleOrigin = utils.envOverride("FIREBASE_CONSOLE_URL", "https://console.firebase.google.com");
exports.deployOrigin = utils.envOverride("FIREBASE_DEPLOY_URL", utils.envOverride("FIREBASE_UPLOAD_URL", "https://deploy.firebase.com"));
exports.dynamicLinksOrigin = utils.envOverride("FIREBASE_DYNAMIC_LINKS_URL", "https://firebasedynamiclinks.googleapis.com");
exports.dynamicLinksKey = utils.envOverride("FIREBASE_DYNAMIC_LINKS_KEY", "AIzaSyB6PtY5vuiSB8MNgt20mQffkOlunZnHYiQ");
exports.eventarcOrigin = utils.envOverride("EVENTARC_URL", "https://eventarc.googleapis.com");
exports.firebaseApiOrigin = utils.envOverride("FIREBASE_API_URL", "https://firebase.googleapis.com");
exports.firebaseExtensionsRegistryOrigin = utils.envOverride("FIREBASE_EXT_REGISTRY_ORIGIN", "https://extensions-registry.firebaseapp.com");
exports.firedataOrigin = utils.envOverride("FIREBASE_FIREDATA_URL", "https://mobilesdk-pa.googleapis.com");
exports.firestoreOriginOrEmulator = utils.envOverride(constants_1.Constants.FIRESTORE_EMULATOR_HOST, utils.envOverride("FIRESTORE_URL", "https://firestore.googleapis.com"), (val) => {
    if (val.startsWith("http")) {
        return val;
    }
    return `http://${val}`;
});
exports.firestoreOrigin = utils.envOverride("FIRESTORE_URL", "https://firestore.googleapis.com");
exports.functionsOrigin = utils.envOverride("FIREBASE_FUNCTIONS_URL", "https://cloudfunctions.googleapis.com");
exports.functionsV2Origin = utils.envOverride("FIREBASE_FUNCTIONS_V2_URL", "https://cloudfunctions.googleapis.com");
exports.runOrigin = utils.envOverride("CLOUD_RUN_URL", "https://run.googleapis.com");
exports.functionsDefaultRegion = utils.envOverride("FIREBASE_FUNCTIONS_DEFAULT_REGION", "us-central1");
exports.cloudbuildOrigin = utils.envOverride("FIREBASE_CLOUDBUILD_URL", "https://cloudbuild.googleapis.com");
exports.cloudschedulerOrigin = utils.envOverride("FIREBASE_CLOUDSCHEDULER_URL", "https://cloudscheduler.googleapis.com");
exports.cloudTasksOrigin = utils.envOverride("FIREBASE_CLOUD_TAKS_URL", "https://cloudtasks.googleapis.com");
exports.pubsubOrigin = utils.envOverride("FIREBASE_PUBSUB_URL", "https://pubsub.googleapis.com");
exports.googleOrigin = utils.envOverride("FIREBASE_TOKEN_URL", utils.envOverride("FIREBASE_GOOGLE_URL", "https://www.googleapis.com"));
exports.hostingOrigin = utils.envOverride("FIREBASE_HOSTING_URL", "https://web.app");
exports.identityOrigin = utils.envOverride("FIREBASE_IDENTITY_URL", "https://identitytoolkit.googleapis.com");
exports.iamOrigin = utils.envOverride("FIREBASE_IAM_URL", "https://iam.googleapis.com");
exports.extensionsOrigin = utils.envOverride("FIREBASE_EXT_URL", "https://firebaseextensions.googleapis.com");
exports.extensionsPublisherOrigin = utils.envOverride("FIREBASE_EXT_PUBLISHER_URL", "https://firebaseextensionspublisher.googleapis.com");
exports.extensionsTOSOrigin = utils.envOverride("FIREBASE_EXT_TOS_URL", "https://firebaseextensionstos-pa.googleapis.com");
exports.realtimeOrigin = utils.envOverride("FIREBASE_REALTIME_URL", "https://firebaseio.com");
exports.rtdbManagementOrigin = utils.envOverride("FIREBASE_RTDB_MANAGEMENT_URL", "https://firebasedatabase.googleapis.com");
exports.rtdbMetadataOrigin = utils.envOverride("FIREBASE_RTDB_METADATA_URL", "https://metadata-dot-firebase-prod.appspot.com");
exports.remoteConfigApiOrigin = utils.envOverride("FIREBASE_REMOTE_CONFIG_URL", "https://firebaseremoteconfig.googleapis.com");
exports.resourceManagerOrigin = utils.envOverride("FIREBASE_RESOURCEMANAGER_URL", "https://cloudresourcemanager.googleapis.com");
exports.rulesOrigin = utils.envOverride("FIREBASE_RULES_URL", "https://firebaserules.googleapis.com");
exports.runtimeconfigOrigin = utils.envOverride("FIREBASE_RUNTIMECONFIG_URL", "https://runtimeconfig.googleapis.com");
exports.storageOrigin = utils.envOverride("FIREBASE_STORAGE_URL", "https://storage.googleapis.com");
exports.firebaseStorageOrigin = utils.envOverride("FIREBASE_FIREBASESTORAGE_URL", "https://firebasestorage.googleapis.com");
exports.hostingApiOrigin = utils.envOverride("FIREBASE_HOSTING_API_URL", "https://firebasehosting.googleapis.com");
exports.cloudRunApiOrigin = utils.envOverride("CLOUD_RUN_API_URL", "https://run.googleapis.com");
exports.serviceUsageOrigin = utils.envOverride("FIREBASE_SERVICE_USAGE_URL", "https://serviceusage.googleapis.com");
exports.frameworksOrigin = utils.envOverride("FRAMEWORKS_URL", "https://placeholder.googleapis.com");
exports.githubOrigin = utils.envOverride("GITHUB_URL", "https://github.com");
exports.githubApiOrigin = utils.envOverride("GITHUB_API_URL", "https://api.github.com");
exports.secretManagerOrigin = utils.envOverride("CLOUD_SECRET_MANAGER_URL", "https://secretmanager.googleapis.com");
exports.githubClientId = utils.envOverride("GITHUB_CLIENT_ID", "89cf50f02ac6aaed3484");
exports.githubClientSecret = utils.envOverride("GITHUB_CLIENT_SECRET", "3330d14abc895d9a74d5f17cd7a00711fa2c5bf0");
function getScopes() {
    return Array.from(commandScopes);
}
exports.getScopes = getScopes;
function setScopes(sps = []) {
    commandScopes = new Set([
        scopes.EMAIL,
        scopes.OPENID,
        scopes.CLOUD_PROJECTS_READONLY,
        scopes.FIREBASE_PLATFORM,
    ]);
    for (const s of sps) {
        commandScopes.add(s);
    }
    logger_1.logger.debug("> command requires scopes:", Array.from(commandScopes));
}
exports.setScopes = setScopes;
