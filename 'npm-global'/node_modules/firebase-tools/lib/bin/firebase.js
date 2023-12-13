#!/usr/bin/env node
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const semver = require("semver");
const pkg = require("../../package.json");
const nodeVersion = process.version;
if (!semver.satisfies(nodeVersion, pkg.engines.node)) {
    console.error(`Firebase CLI v${pkg.version} is incompatible with Node.js ${nodeVersion} Please upgrade Node.js to version ${pkg.engines.node}`);
    process.exit(1);
}
const updateNotifierPkg = require("update-notifier-cjs");
const clc = require("colorette");
const TerminalRenderer = require("marked-terminal");
const updateNotifier = updateNotifierPkg({ pkg });
const marked_1 = require("marked");
marked_1.marked.setOptions({
    renderer: new TerminalRenderer(),
});
const node_path_1 = require("node:path");
const triple_beam_1 = require("triple-beam");
const stripAnsi = require("strip-ansi");
const fs = require("node:fs");
const configstore_1 = require("../configstore");
const errorOut_1 = require("../errorOut");
const handlePreviewToggles_1 = require("../handlePreviewToggles");
const logger_1 = require("../logger");
const client = require("..");
const fsutils = require("../fsutils");
const utils = require("../utils");
const winston = require("winston");
let args = process.argv.slice(2);
let cmd;
function findAvailableLogFile() {
    const candidates = ["firebase-debug.log"];
    for (let i = 1; i < 10; i++) {
        candidates.push(`firebase-debug.${i}.log`);
    }
    for (const c of candidates) {
        const logFilename = (0, node_path_1.join)(process.cwd(), c);
        try {
            const fd = fs.openSync(logFilename, "r+");
            fs.closeSync(fd);
            return logFilename;
        }
        catch (e) {
            if (e.code === "ENOENT") {
                return logFilename;
            }
        }
    }
    throw new Error("Unable to obtain permissions for firebase-debug.log");
}
const logFilename = findAvailableLogFile();
if (!process.env.DEBUG && args.includes("--debug")) {
    process.env.DEBUG = "true";
}
process.env.IS_FIREBASE_CLI = "true";
logger_1.logger.add(new winston.transports.File({
    level: "debug",
    filename: logFilename,
    format: winston.format.printf((info) => {
        const segments = [info.message, ...(info[triple_beam_1.SPLAT] || [])].map(utils.tryStringify);
        return `[${info.level}] ${stripAnsi(segments.join(" "))}`;
    }),
}));
logger_1.logger.debug("-".repeat(70));
logger_1.logger.debug("Command:      ", process.argv.join(" "));
logger_1.logger.debug("CLI Version:  ", pkg.version);
logger_1.logger.debug("Platform:     ", process.platform);
logger_1.logger.debug("Node Version: ", process.version);
logger_1.logger.debug("Time:         ", new Date().toString());
if (utils.envOverrides.length) {
    logger_1.logger.debug("Env Overrides:", utils.envOverrides.join(", "));
}
logger_1.logger.debug("-".repeat(70));
logger_1.logger.debug();
const experiments_1 = require("../experiments");
const fetchMOTD_1 = require("../fetchMOTD");
(0, experiments_1.enableExperimentsFromCliEnvVariable)();
(0, fetchMOTD_1.fetchMOTD)();
process.on("exit", (code) => {
    code = process.exitCode || code;
    if (!process.env.DEBUG && code < 2 && fsutils.fileExistsSync(logFilename)) {
        fs.unlinkSync(logFilename);
    }
    if (code > 0 && process.stdout.isTTY) {
        const lastError = configstore_1.configstore.get("lastError") || 0;
        const timestamp = Date.now();
        if (lastError > timestamp - 120000) {
            let help;
            if (code === 1 && cmd) {
                help = "Having trouble? Try " + clc.bold("firebase [command] --help");
            }
            else {
                help = "Having trouble? Try again or contact support with contents of firebase-debug.log";
            }
            if (cmd) {
                console.log();
                console.log(help);
            }
        }
        configstore_1.configstore.set("lastError", timestamp);
    }
    else {
        configstore_1.configstore.delete("lastError");
    }
    try {
        const updateMessage = `Update available ${clc.gray("{currentVersion}")} → ${clc.green("{latestVersion}")}\n` +
            `To update to the latest version using npm, run\n${clc.cyan("npm install -g firebase-tools")}\n` +
            `For other CLI management options, visit the ${(0, marked_1.marked)("[CLI documentation](https://firebase.google.com/docs/cli#update-cli)")}`;
        updateNotifier.notify({ defer: false, isGlobal: true, message: updateMessage });
    }
    catch (err) {
        logger_1.logger.debug("Error when notifying about new CLI updates:");
        if (err instanceof Error) {
            logger_1.logger.debug(err);
        }
        else {
            logger_1.logger.debug(`${err}`);
        }
    }
});
process.on("uncaughtException", (err) => {
    (0, errorOut_1.errorOut)(err);
});
if (!(0, handlePreviewToggles_1.handlePreviewToggles)(args)) {
    cmd = client.cli.parse(process.argv);
    args = args.filter((arg) => !arg.includes("-"));
    if (!args.length) {
        client.cli.help();
    }
}
