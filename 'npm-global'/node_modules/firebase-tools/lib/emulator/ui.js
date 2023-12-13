"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EmulatorUI = void 0;
const types_1 = require("./types");
const downloadableEmulators = require("./downloadableEmulators");
const registry_1 = require("./registry");
const error_1 = require("../error");
const constants_1 = require("./constants");
const track_1 = require("../track");
const ExpressBasedEmulator_1 = require("./ExpressBasedEmulator");
const experiments_1 = require("../experiments");
class EmulatorUI {
    constructor(args) {
        this.args = args;
    }
    start() {
        if (!registry_1.EmulatorRegistry.isRunning(types_1.Emulators.HUB)) {
            throw new error_1.FirebaseError(`Cannot start ${constants_1.Constants.description(types_1.Emulators.UI)} without ${constants_1.Constants.description(types_1.Emulators.HUB)}!`);
        }
        const { auto_download: autoDownload, projectId } = this.args;
        const env = {
            LISTEN: JSON.stringify(ExpressBasedEmulator_1.ExpressBasedEmulator.listenOptionsFromSpecs(this.args.listen)),
            GCLOUD_PROJECT: projectId,
            [constants_1.Constants.FIREBASE_EMULATOR_HUB]: registry_1.EmulatorRegistry.url(types_1.Emulators.HUB).host,
        };
        const session = (0, track_1.emulatorSession)();
        if (session) {
            env[constants_1.Constants.FIREBASE_GA_SESSION] = JSON.stringify(session);
        }
        const enabledExperiments = Object.keys(experiments_1.ALL_EXPERIMENTS).filter((experimentName) => (0, experiments_1.isEnabled)(experimentName));
        env[constants_1.Constants.FIREBASE_ENABLED_EXPERIMENTS] = JSON.stringify(enabledExperiments);
        return downloadableEmulators.start(types_1.Emulators.UI, { auto_download: autoDownload }, env);
    }
    connect() {
        return Promise.resolve();
    }
    stop() {
        return downloadableEmulators.stop(types_1.Emulators.UI);
    }
    getInfo() {
        return {
            name: this.getName(),
            host: this.args.listen[0].address,
            port: this.args.listen[0].port,
            pid: downloadableEmulators.getPID(types_1.Emulators.UI),
        };
    }
    getName() {
        return types_1.Emulators.UI;
    }
}
exports.EmulatorUI = EmulatorUI;
