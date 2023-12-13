"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setup = void 0;
const fs = require("fs");
const path = require("path");
const npm_dependencies_1 = require("./npm-dependencies");
const prompt_1 = require("../../../prompt");
const projectConfig_1 = require("../../../functions/projectConfig");
const TEMPLATE_ROOT = path.resolve(__dirname, "../../../../templates/init/functions/javascript/");
const INDEX_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "index.js"), "utf8");
const PACKAGE_LINTING_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "package.lint.json"), "utf8");
const PACKAGE_NO_LINTING_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "package.nolint.json"), "utf8");
const ESLINT_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "_eslintrc"), "utf8");
const GITIGNORE_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "_gitignore"), "utf8");
function setup(setup, config) {
    return (0, prompt_1.prompt)(setup.functions, [
        {
            name: "lint",
            type: "confirm",
            message: "Do you want to use ESLint to catch probable bugs and enforce style?",
            default: false,
        },
    ])
        .then(() => {
        if (setup.functions.lint) {
            const cbconfig = (0, projectConfig_1.configForCodebase)(setup.config.functions, setup.functions.codebase);
            cbconfig.predeploy = ['npm --prefix "$RESOURCE_DIR" run lint'];
            return config
                .askWriteProjectFile(`${setup.functions.source}/package.json`, PACKAGE_LINTING_TEMPLATE)
                .then(() => {
                config.askWriteProjectFile(`${setup.functions.source}/.eslintrc.js`, ESLINT_TEMPLATE);
            });
        }
        return config.askWriteProjectFile(`${setup.functions.source}/package.json`, PACKAGE_NO_LINTING_TEMPLATE);
    })
        .then(() => {
        return config.askWriteProjectFile(`${setup.functions.source}/index.js`, INDEX_TEMPLATE);
    })
        .then(() => {
        return config.askWriteProjectFile(`${setup.functions.source}/.gitignore`, GITIGNORE_TEMPLATE);
    })
        .then(() => {
        return (0, npm_dependencies_1.askInstallDependencies)(setup.functions, config);
    });
}
exports.setup = setup;
