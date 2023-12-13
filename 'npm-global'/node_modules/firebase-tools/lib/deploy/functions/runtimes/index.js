"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getRuntimeDelegate = exports.getHumanFriendlyRuntimeName = exports.isValidRuntime = exports.isDeprecatedRuntime = void 0;
const node = require("./node");
const python = require("./python");
const validate = require("../validate");
const error_1 = require("../../../error");
const RUNTIMES = [
    "nodejs10",
    "nodejs12",
    "nodejs14",
    "nodejs16",
    "nodejs18",
    "nodejs20",
    "python310",
    "python311",
];
const EXPERIMENTAL_RUNTIMES = [];
const DEPRECATED_RUNTIMES = ["nodejs6", "nodejs8"];
function isDeprecatedRuntime(runtime) {
    return DEPRECATED_RUNTIMES.includes(runtime);
}
exports.isDeprecatedRuntime = isDeprecatedRuntime;
function isValidRuntime(runtime) {
    return RUNTIMES.includes(runtime) || EXPERIMENTAL_RUNTIMES.includes(runtime);
}
exports.isValidRuntime = isValidRuntime;
const MESSAGE_FRIENDLY_RUNTIMES = {
    nodejs6: "Node.js 6 (Deprecated)",
    nodejs8: "Node.js 8 (Deprecated)",
    nodejs10: "Node.js 10",
    nodejs12: "Node.js 12",
    nodejs14: "Node.js 14",
    nodejs16: "Node.js 16",
    nodejs18: "Node.js 18",
    nodejs20: "Node.js 20",
    python310: "Python 3.10",
    python311: "Python 3.11",
};
function getHumanFriendlyRuntimeName(runtime) {
    return MESSAGE_FRIENDLY_RUNTIMES[runtime] || runtime;
}
exports.getHumanFriendlyRuntimeName = getHumanFriendlyRuntimeName;
const factories = [node.tryCreateDelegate, python.tryCreateDelegate];
async function getRuntimeDelegate(context) {
    const { projectDir, sourceDir, runtime } = context;
    validate.functionsDirectoryExists(sourceDir, projectDir);
    if (runtime && !isValidRuntime(runtime)) {
        throw new error_1.FirebaseError(`Cannot deploy function with runtime ${runtime}`);
    }
    for (const factory of factories) {
        const delegate = await factory(context);
        if (delegate) {
            return delegate;
        }
    }
    throw new error_1.FirebaseError(`Could not detect language for functions at ${sourceDir}`);
}
exports.getRuntimeDelegate = getRuntimeDelegate;
