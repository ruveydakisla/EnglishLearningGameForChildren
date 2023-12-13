"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.askInstallDependencies = void 0;
const spawn = require("cross-spawn");
const logger_1 = require("../../../logger");
const prompt_1 = require("../../../prompt");
function askInstallDependencies(setup, config) {
    return (0, prompt_1.prompt)(setup, [
        {
            name: "npm",
            type: "confirm",
            message: "Do you want to install dependencies with npm now?",
            default: true,
        },
    ]).then(() => {
        if (setup.npm) {
            return new Promise((resolve) => {
                const installer = spawn("npm", ["install"], {
                    cwd: config.projectDir + `/${setup.source}`,
                    stdio: "inherit",
                });
                installer.on("error", (err) => {
                    logger_1.logger.debug(err.stack);
                });
                installer.on("close", (code) => {
                    if (code === 0) {
                        return resolve();
                    }
                    logger_1.logger.info();
                    logger_1.logger.error("NPM install failed, continuing with Firebase initialization...");
                    return resolve();
                });
            });
        }
    });
}
exports.askInstallDependencies = askInstallDependencies;
