"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.init = void 0;
const lodash_1 = require("lodash");
const clc = require("colorette");
const error_1 = require("../error");
const logger_1 = require("../logger");
const features = require("./features");
const experiments_1 = require("../experiments");
const featureFns = new Map([
    ["account", features.account],
    ["database", features.database],
    ["firestore", features.firestore],
    ["functions", features.functions],
    ["hosting", features.hosting],
    ["storage", features.storage],
    ["emulators", features.emulators],
    ["extensions", features.extensions],
    ["project", features.project],
    ["remoteconfig", features.remoteconfig],
    ["hosting:github", features.hostingGithub],
]);
if ((0, experiments_1.isEnabled)("internalframeworks")) {
    featureFns.set("internalframeworks", features.frameworks);
}
async function init(setup, config, options) {
    var _a;
    const nextFeature = (_a = setup.features) === null || _a === void 0 ? void 0 : _a.shift();
    if (nextFeature) {
        if (!featureFns.has(nextFeature)) {
            const availableFeatures = Object.keys(features)
                .filter((f) => f !== "project")
                .join(", ");
            throw new error_1.FirebaseError(`${clc.bold(nextFeature)} is not a valid feature. Must be one of ${availableFeatures}`);
        }
        logger_1.logger.info(clc.bold(`\n${clc.white("===")} ${(0, lodash_1.capitalize)(nextFeature)} Setup`));
        const fn = featureFns.get(nextFeature);
        if (!fn) {
            throw new error_1.FirebaseError(`We've lost the function to init ${nextFeature}`, { exit: 2 });
        }
        await fn(setup, config, options);
        return init(setup, config, options);
    }
}
exports.init = init;
