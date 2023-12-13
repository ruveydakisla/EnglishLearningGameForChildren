"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.detectFromPort = exports.detectFromYaml = exports.yamlToBuild = exports.readFileAsync = void 0;
const node_fetch_1 = require("node-fetch");
const fs = require("fs");
const path = require("path");
const yaml = require("js-yaml");
const util_1 = require("util");
const logger_1 = require("../../../../logger");
const api = require("../../.../../../../api");
const v1alpha1 = require("./v1alpha1");
const error_1 = require("../../../../error");
exports.readFileAsync = (0, util_1.promisify)(fs.readFile);
function yamlToBuild(yaml, project, region, runtime) {
    try {
        if (!yaml.specVersion) {
            throw new error_1.FirebaseError("Expect manifest yaml to specify a version number");
        }
        if (yaml.specVersion === "v1alpha1") {
            return v1alpha1.buildFromV1Alpha1(yaml, project, region, runtime);
        }
        throw new error_1.FirebaseError("It seems you are using a newer SDK than this version of the CLI can handle. Please update your CLI with `npm install -g firebase-tools`");
    }
    catch (err) {
        throw new error_1.FirebaseError("Failed to parse build specification", { children: [err] });
    }
}
exports.yamlToBuild = yamlToBuild;
async function detectFromYaml(directory, project, runtime) {
    let text;
    try {
        text = await exports.readFileAsync(path.join(directory, "functions.yaml"), "utf8");
    }
    catch (err) {
        if (err.code === "ENOENT") {
            logger_1.logger.debug("Could not find functions.yaml. Must use http discovery");
        }
        else {
            logger_1.logger.debug("Unexpected error looking for functions.yaml file:", err);
        }
        return;
    }
    logger_1.logger.debug("Found functions.yaml. Got spec:", text);
    const parsed = yaml.load(text);
    return yamlToBuild(parsed, project, api.functionsDefaultRegion, runtime);
}
exports.detectFromYaml = detectFromYaml;
async function detectFromPort(port, project, runtime, timeout = 10000) {
    let res;
    const timedOut = new Promise((resolve, reject) => {
        setTimeout(() => {
            reject(new error_1.FirebaseError("User code failed to load. Cannot determine backend specification"));
        }, timeout);
    });
    while (true) {
        try {
            res = await Promise.race([(0, node_fetch_1.default)(`http://127.0.0.1:${port}/__/functions.yaml`), timedOut]);
            break;
        }
        catch (err) {
            if ((err === null || err === void 0 ? void 0 : err.code) === "ECONNREFUSED") {
                continue;
            }
            throw err;
        }
    }
    if (res.status !== 200) {
        const text = await res.text();
        logger_1.logger.debug(`Got response code ${res.status}; body ${text}`);
        throw new error_1.FirebaseError("Functions codebase could not be analyzed successfully. " +
            "It may have a syntax or runtime error");
    }
    const text = await res.text();
    logger_1.logger.debug("Got response from /__/functions.yaml", text);
    let parsed;
    try {
        parsed = yaml.load(text);
    }
    catch (err) {
        logger_1.logger.debug("Failed to parse functions.yaml", err);
        throw new error_1.FirebaseError(`Failed to load function definition from source: ${text}`);
    }
    return yamlToBuild(parsed, project, api.functionsDefaultRegion, runtime);
}
exports.detectFromPort = detectFromPort;
