"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setEnvVarsForEmulators = void 0;
const constants_1 = require("./constants");
const types_1 = require("./types");
const functionsEmulatorShared_1 = require("./functionsEmulatorShared");
function setEnvVarsForEmulators(env, emulators) {
    for (const emu of emulators) {
        const host = (0, functionsEmulatorShared_1.formatHost)(emu);
        switch (emu.name) {
            case types_1.Emulators.FIRESTORE:
                env[constants_1.Constants.FIRESTORE_EMULATOR_HOST] = host;
                env[constants_1.Constants.FIRESTORE_EMULATOR_ENV_ALT] = host;
                break;
            case types_1.Emulators.DATABASE:
                env[constants_1.Constants.FIREBASE_DATABASE_EMULATOR_HOST] = host;
                break;
            case types_1.Emulators.STORAGE:
                env[constants_1.Constants.FIREBASE_STORAGE_EMULATOR_HOST] = host;
                env[constants_1.Constants.CLOUD_STORAGE_EMULATOR_HOST] = `http://${host}`;
                break;
            case types_1.Emulators.AUTH:
                env[constants_1.Constants.FIREBASE_AUTH_EMULATOR_HOST] = host;
                break;
            case types_1.Emulators.HUB:
                env[constants_1.Constants.FIREBASE_EMULATOR_HUB] = host;
                break;
            case types_1.Emulators.PUBSUB:
                env[constants_1.Constants.PUBSUB_EMULATOR_HOST] = host;
                break;
            case types_1.Emulators.EVENTARC:
                env[constants_1.Constants.CLOUD_EVENTARC_EMULATOR_HOST] = `http://${host}`;
                break;
        }
    }
}
exports.setEnvVarsForEmulators = setEnvVarsForEmulators;
