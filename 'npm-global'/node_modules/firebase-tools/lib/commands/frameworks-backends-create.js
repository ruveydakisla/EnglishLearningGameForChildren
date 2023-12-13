"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const command_1 = require("../command");
const projectUtils_1 = require("../projectUtils");
const requireInteractive_1 = require("../requireInteractive");
const frameworks_1 = require("../init/features/frameworks");
exports.command = new command_1.Command("backends:create")
    .description("Create a backend in a Firebase project")
    .before(requireInteractive_1.default)
    .action(async (options) => {
    const projectId = (0, projectUtils_1.needProjectId)(options);
    await (0, frameworks_1.doSetup)(options, projectId);
});
