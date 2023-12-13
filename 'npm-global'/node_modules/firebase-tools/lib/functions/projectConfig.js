"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.configForCodebase = exports.normalizeAndValidate = exports.validate = exports.assertUnique = exports.validateCodebase = exports.normalize = exports.DEFAULT_CODEBASE = void 0;
const error_1 = require("../error");
exports.DEFAULT_CODEBASE = "default";
function normalize(config) {
    if (!config) {
        throw new error_1.FirebaseError("No valid functions configuration detected in firebase.json");
    }
    if (Array.isArray(config)) {
        if (config.length < 1) {
            throw new error_1.FirebaseError("Requires at least one functions.source in firebase.json.");
        }
        return config;
    }
    return [config];
}
exports.normalize = normalize;
function validateCodebase(codebase) {
    if (codebase.length === 0 || codebase.length > 63 || !/^[a-z0-9_-]+$/.test(codebase)) {
        throw new error_1.FirebaseError("Invalid codebase name. Codebase must be less than 64 characters and " +
            "can contain only lowercase letters, numeric characters, underscores, and dashes.");
    }
}
exports.validateCodebase = validateCodebase;
function validateSingle(config) {
    if (!config.source) {
        throw new error_1.FirebaseError("codebase source must be specified");
    }
    if (!config.codebase) {
        config.codebase = exports.DEFAULT_CODEBASE;
    }
    validateCodebase(config.codebase);
    return Object.assign(Object.assign({}, config), { source: config.source, codebase: config.codebase });
}
function assertUnique(config, property, propval) {
    const values = new Set();
    if (propval) {
        values.add(propval);
    }
    for (const single of config) {
        const value = single[property];
        if (values.has(value)) {
            throw new error_1.FirebaseError(`functions.${property} must be unique but '${value}' was used more than once.`);
        }
        values.add(value);
    }
}
exports.assertUnique = assertUnique;
function validate(config) {
    const validated = config.map((cfg) => validateSingle(cfg));
    assertUnique(validated, "source");
    assertUnique(validated, "codebase");
    return validated;
}
exports.validate = validate;
function normalizeAndValidate(config) {
    return validate(normalize(config));
}
exports.normalizeAndValidate = normalizeAndValidate;
function configForCodebase(config, codebase) {
    const codebaseCfg = config.find((c) => c.codebase === codebase);
    if (!codebaseCfg) {
        throw new error_1.FirebaseError(`No functions config found for codebase ${codebase}`);
    }
    return codebaseCfg;
}
exports.configForCodebase = configForCodebase;
