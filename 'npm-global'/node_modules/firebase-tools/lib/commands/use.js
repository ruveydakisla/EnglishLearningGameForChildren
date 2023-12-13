"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.command = void 0;
const clc = require("colorette");
const command_1 = require("../command");
const projects_1 = require("../management/projects");
const logger_1 = require("../logger");
const prompt_1 = require("../prompt");
const requireAuth_1 = require("../requireAuth");
const command_2 = require("../command");
const utils = require("../utils");
function listAliases(options) {
    if (options.rc.hasProjects) {
        logger_1.logger.info("Project aliases for", clc.bold(options.projectRoot || "") + ":");
        logger_1.logger.info();
        for (const [alias, projectId] of Object.entries(options.rc.projects)) {
            const listing = alias + " (" + projectId + ")";
            if (options.project === projectId || options.projectAlias === alias) {
                logger_1.logger.info(clc.cyan(clc.bold("* " + listing)));
            }
            else {
                logger_1.logger.info("  " + listing);
            }
        }
        logger_1.logger.info();
    }
    logger_1.logger.info("Run", clc.bold("firebase use --add"), "to define a new project alias.");
}
function verifyMessage(name) {
    return "please verify project " + clc.bold(name) + " exists and you have access.";
}
exports.command = new command_1.Command("use [alias_or_project_id]")
    .description("set an active Firebase project for your working directory")
    .option("--add", "create a new project alias interactively")
    .option("--alias <name>", "create a new alias for the provided project id")
    .option("--unalias <name>", "remove an already created project alias")
    .option("--clear", "clear the active project selection")
    .before(requireAuth_1.requireAuth)
    .action((newActive, options) => {
    let aliasOpt;
    const i = process.argv.indexOf("--alias");
    if (i >= 0 && process.argv.length > i + 1) {
        aliasOpt = process.argv[i + 1];
    }
    if (!options.projectRoot) {
        return utils.reject(clc.bold("firebase use") +
            " must be run from a Firebase project directory.\n\nRun " +
            clc.bold("firebase init") +
            " to start a project directory in the current folder.");
    }
    if (newActive) {
        let project;
        const hasAlias = options.rc.hasProjectAlias(newActive);
        const resolvedProject = options.rc.resolveAlias(newActive);
        (0, command_2.validateProjectId)(resolvedProject);
        return (0, projects_1.getFirebaseProject)(resolvedProject)
            .then((foundProject) => {
            project = foundProject;
        })
            .catch(() => {
            return utils.reject("Invalid project selection, " + verifyMessage(newActive));
        })
            .then(() => {
            if (aliasOpt) {
                if (!project) {
                    return utils.reject("Cannot create alias " + clc.bold(aliasOpt) + ", " + verifyMessage(newActive));
                }
                options.rc.addProjectAlias(aliasOpt, newActive);
                logger_1.logger.info("Created alias", clc.bold(aliasOpt), "for", resolvedProject + ".");
            }
            if (hasAlias) {
                if (!project) {
                    return utils.reject("Unable to use alias " + clc.bold(newActive) + ", " + verifyMessage(resolvedProject));
                }
                utils.makeActiveProject(options.projectRoot, newActive);
                logger_1.logger.info("Now using alias", clc.bold(newActive), "(" + resolvedProject + ")");
            }
            else if (project) {
                utils.makeActiveProject(options.projectRoot, newActive);
                logger_1.logger.info("Now using project", clc.bold(newActive));
            }
            else {
                return utils.reject("Invalid project selection, " + verifyMessage(newActive));
            }
        });
    }
    else if (options.unalias) {
        if (options.rc.hasProjectAlias(options.unalias)) {
            options.rc.removeProjectAlias(options.unalias);
            logger_1.logger.info("Removed alias", clc.bold(options.unalias));
            logger_1.logger.info();
            listAliases(options);
        }
    }
    else if (options.add) {
        if (options.nonInteractive) {
            return utils.reject("Cannot run " +
                clc.bold("firebase use --add") +
                " in non-interactive mode. Use " +
                clc.bold("firebase use <project_id> --alias <alias>") +
                " instead.");
        }
        return (0, projects_1.listFirebaseProjects)().then((projects) => {
            const results = {};
            return (0, prompt_1.prompt)(results, [
                {
                    type: "list",
                    name: "project",
                    message: "Which project do you want to add?",
                    choices: projects.map((p) => p.projectId).sort(),
                },
                {
                    type: "input",
                    name: "alias",
                    message: "What alias do you want to use for this project? (e.g. staging)",
                    validate: (input) => {
                        return input && input.length > 0;
                    },
                },
            ]).then(() => {
                options.rc.addProjectAlias(results.alias, results.project);
                utils.makeActiveProject(options.projectRoot, results.alias);
                logger_1.logger.info();
                logger_1.logger.info("Created alias", clc.bold(results.alias || ""), "for", results.project + ".");
                logger_1.logger.info("Now using alias", clc.bold(results.alias || "") + " (" + results.project + ")");
            });
        });
    }
    else if (options.clear) {
        utils.makeActiveProject(options.projectRoot, undefined);
        options.projectAlias = null;
        options.project = null;
        logger_1.logger.info("Cleared active project.");
        logger_1.logger.info();
        listAliases(options);
    }
    else {
        if (options.nonInteractive || !process.stdout.isTTY) {
            if (options.project) {
                logger_1.logger.info(options.project);
                return options.project;
            }
            return utils.reject("No active project");
        }
        if (options.projectAlias) {
            logger_1.logger.info("Active Project:", clc.bold(clc.cyan(options.projectAlias + " (" + options.project + ")")));
        }
        else if (options.project) {
            logger_1.logger.info("Active Project:", clc.bold(clc.cyan(options.project)));
        }
        else {
            let msg = "No project is currently active";
            if (options.rc.hasProjects) {
                msg += ", and no aliases have been created.";
            }
            logger_1.logger.info(msg + ".");
        }
        logger_1.logger.info();
        listAliases(options);
        return options.project;
    }
});
