"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const functionsShellCommandAction_1 = require("../functionsShellCommandAction");
const command_1 = require("../command");
const requireConfig_1 = require("../requireConfig");
const requirePermissions_1 = require("../requirePermissions");
exports.command = new command_1.Command("experimental:functions:shell")
    .description("launch full Node shell with emulated functions. (Alias for `firebase functions:shell.)")
    .option("-p, --port <port>", "the port on which to emulate functions (default: 5000)", 5000)
    .before(requireConfig_1.requireConfig)
    .before(requirePermissions_1.requirePermissions)
    .action(functionsShellCommandAction_1.actionFunction);
