"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.confirm = exports.promptOnce = exports.prompt = void 0;
const inquirer = require("inquirer");
const error_1 = require("./error");
async function prompt(options, questions) {
    const prompts = [];
    for (const question of questions) {
        if (question.name && options[question.name] === undefined) {
            prompts.push(question);
        }
    }
    if (prompts.length && options.nonInteractive) {
        const missingOptions = Array.from(new Set(prompts.map((p) => p.name))).join(", ");
        throw new error_1.FirebaseError(`Missing required options (${missingOptions}) while running in non-interactive mode`, {
            children: prompts,
        });
    }
    const answers = await inquirer.prompt(prompts);
    Object.keys(answers).forEach((k) => {
        options[k] = answers[k];
    });
    return answers;
}
exports.prompt = prompt;
async function promptOnce(question, options = {}) {
    var _a;
    question.name = ((_a = question.name) === null || _a === void 0 ? void 0 : _a.replace(/\./g, "/")) || "question";
    await prompt(options, [question]);
    return options[question.name];
}
exports.promptOnce = promptOnce;
async function confirm(args) {
    var _a;
    if (!args.nonInteractive && !args.force) {
        const message = (_a = args.message) !== null && _a !== void 0 ? _a : `Do you wish to continue?`;
        return await promptOnce({
            type: "confirm",
            message,
            default: args.default,
        });
    }
    else if (args.nonInteractive && !args.force) {
        throw new error_1.FirebaseError("Pass the --force flag to use this command in non-interactive mode");
    }
    else {
        return true;
    }
}
exports.confirm = confirm;
