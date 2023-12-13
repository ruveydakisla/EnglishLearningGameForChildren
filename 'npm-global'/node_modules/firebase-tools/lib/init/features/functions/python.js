"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setup = void 0;
const fs = require("fs");
const spawn = require("cross-spawn");
const path = require("path");
const python_1 = require("../../../deploy/functions/runtimes/python");
const python_2 = require("../../../functions/python");
const prompt_1 = require("../../../prompt");
const TEMPLATE_ROOT = path.resolve(__dirname, "../../../../templates/init/functions/python");
const MAIN_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "main.py"), "utf8");
const REQUIREMENTS_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "requirements.txt"), "utf8");
const GITIGNORE_TEMPLATE = fs.readFileSync(path.join(TEMPLATE_ROOT, "_gitignore"), "utf8");
async function setup(setup, config) {
    await config.askWriteProjectFile(`${setup.functions.source}/requirements.txt`, REQUIREMENTS_TEMPLATE);
    await config.askWriteProjectFile(`${setup.functions.source}/.gitignore`, GITIGNORE_TEMPLATE);
    await config.askWriteProjectFile(`${setup.functions.source}/main.py`, MAIN_TEMPLATE);
    config.set("functions.runtime", python_1.LATEST_VERSION);
    config.set("functions.ignore", ["venv", "__pycache__"]);
    const venvProcess = spawn((0, python_1.getPythonBinary)(python_1.LATEST_VERSION), ["-m", "venv", "venv"], {
        shell: true,
        cwd: config.path(setup.functions.source),
        stdio: ["pipe", "pipe", "pipe", "pipe"],
    });
    await new Promise((resolve, reject) => {
        venvProcess.on("exit", resolve);
        venvProcess.on("error", reject);
    });
    const install = await (0, prompt_1.promptOnce)({
        name: "install",
        type: "confirm",
        message: "Do you want to install dependencies now?",
        default: true,
    });
    if (install) {
        const upgradeProcess = (0, python_2.runWithVirtualEnv)(["pip3", "install", "--upgrade", "pip"], config.path(setup.functions.source), {}, { stdio: ["inherit", "inherit", "inherit"] });
        await new Promise((resolve, reject) => {
            upgradeProcess.on("exit", resolve);
            upgradeProcess.on("error", reject);
        });
        const installProcess = (0, python_2.runWithVirtualEnv)([(0, python_1.getPythonBinary)(python_1.LATEST_VERSION), "-m", "pip", "install", "-r", "requirements.txt"], config.path(setup.functions.source), {}, { stdio: ["inherit", "inherit", "inherit"] });
        await new Promise((resolve, reject) => {
            installProcess.on("exit", resolve);
            installProcess.on("error", reject);
        });
    }
}
exports.setup = setup;
