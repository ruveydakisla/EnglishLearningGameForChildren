"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isMonospaceEnv = exports.selectProjectInMonospace = void 0;
const node_fetch_1 = require("node-fetch");
const error_1 = require("../error");
const logger_1 = require("../logger");
const rc_1 = require("../rc");
const POLL_USER_RESPONSE_MILLIS = 2000;
async function selectProjectInMonospace({ projectRoot, project, isVSCE, }) {
    const initFirebaseResponse = await initFirebase(project);
    if (initFirebaseResponse.success === false) {
        throw new Error(String(initFirebaseResponse.error));
    }
    const { rid } = initFirebaseResponse;
    const authorizedProject = await pollAuthorizedProject(rid);
    if (!authorizedProject)
        return null;
    if (isVSCE)
        return authorizedProject;
    if (projectRoot)
        createFirebaseRc(projectRoot, authorizedProject);
}
exports.selectProjectInMonospace = selectProjectInMonospace;
async function pollAuthorizedProject(rid) {
    const getInitFirebaseRes = await getInitFirebaseResponse(rid);
    if ("userResponse" in getInitFirebaseRes) {
        if (getInitFirebaseRes.userResponse.success) {
            return getInitFirebaseRes.userResponse.projectId;
        }
        return null;
    }
    const { error } = getInitFirebaseRes;
    if (error === "WAITING_FOR_RESPONSE") {
        await new Promise((res) => setTimeout(res, POLL_USER_RESPONSE_MILLIS));
        return pollAuthorizedProject(rid);
    }
    if (error === "USER_CANCELED") {
        throw new error_1.FirebaseError("User canceled without authorizing any project");
    }
    throw new error_1.FirebaseError(`Unhandled /get-init-firebase-response error`, {
        original: new Error(error),
    });
}
async function initFirebase(project) {
    const port = getMonospaceDaemonPort();
    if (!port)
        throw new error_1.FirebaseError("Undefined MONOSPACE_DAEMON_PORT");
    const initFirebaseURL = new URL(`http://localhost:${port}/init-firebase`);
    if (project) {
        initFirebaseURL.searchParams.set("known_project", project);
    }
    const initFirebaseRes = await (0, node_fetch_1.default)(initFirebaseURL.toString(), {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
    });
    const initFirebaseResponse = (await initFirebaseRes.json());
    return initFirebaseResponse;
}
async function getInitFirebaseResponse(rid) {
    const port = getMonospaceDaemonPort();
    if (!port)
        throw new error_1.FirebaseError("Undefined MONOSPACE_DAEMON_PORT");
    const getInitFirebaseRes = await (0, node_fetch_1.default)(`http://localhost:${port}/get-init-firebase-response?rid=${rid}`);
    const getInitFirebaseJson = (await getInitFirebaseRes.json());
    logger_1.logger.debug(`/get-init-firebase-response?rid=${rid} response:`);
    logger_1.logger.debug(getInitFirebaseJson);
    return getInitFirebaseJson;
}
function createFirebaseRc(projectDir, authorizedProject) {
    const firebaseRc = (0, rc_1.loadRC)({ cwd: projectDir });
    firebaseRc.addProjectAlias("default", authorizedProject);
    return firebaseRc.save();
}
function isMonospaceEnv() {
    return getMonospaceDaemonPort() !== undefined;
}
exports.isMonospaceEnv = isMonospaceEnv;
function getMonospaceDaemonPort() {
    return process.env.MONOSPACE_DAEMON_PORT;
}
