"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getDevModeHandle = exports.ɵcodegenPublicDirectory = exports.build = exports.discover = exports.vitePluginDiscover = exports.viteDiscoverWithNpmDependency = exports.init = exports.initViteTemplate = exports.DEFAULT_BUILD_SCRIPT = exports.type = exports.support = exports.name = void 0;
const child_process_1 = require("child_process");
const cross_spawn_1 = require("cross-spawn");
const fs_1 = require("fs");
const fs_extra_1 = require("fs-extra");
const path_1 = require("path");
const prompt_1 = require("../../prompt");
const utils_1 = require("../utils");
exports.name = "Vite";
exports.support = "experimental";
exports.type = 4;
exports.DEFAULT_BUILD_SCRIPT = ["vite build", "tsc && vite build"];
const initViteTemplate = (template) => async (setup, config) => await init(setup, config, template);
exports.initViteTemplate = initViteTemplate;
async function init(setup, config, baseTemplate = "vanilla") {
    const template = await (0, prompt_1.promptOnce)({
        type: "list",
        default: "JavaScript",
        message: "What language would you like to use?",
        choices: [
            { name: "JavaScript", value: baseTemplate },
            { name: "TypeScript", value: `${baseTemplate}-ts` },
        ],
    });
    (0, child_process_1.execSync)(`npm create vite@latest ${setup.hosting.source} --yes -- --template ${template}`, {
        stdio: "inherit",
        cwd: config.projectDir,
    });
    (0, child_process_1.execSync)(`npm install`, { stdio: "inherit", cwd: (0, path_1.join)(config.projectDir, setup.hosting.source) });
}
exports.init = init;
const viteDiscoverWithNpmDependency = (dep) => async (dir) => await discover(dir, undefined, dep);
exports.viteDiscoverWithNpmDependency = viteDiscoverWithNpmDependency;
const vitePluginDiscover = (plugin) => async (dir) => await discover(dir, plugin);
exports.vitePluginDiscover = vitePluginDiscover;
async function discover(dir, plugin, npmDependency) {
    if (!(0, fs_1.existsSync)((0, path_1.join)(dir, "package.json")))
        return;
    const additionalDep = npmDependency && (0, utils_1.findDependency)(npmDependency, { cwd: dir, depth: 0, omitDev: false });
    const depth = plugin ? undefined : 0;
    const configFilesExist = await Promise.all([
        (0, fs_extra_1.pathExists)((0, path_1.join)(dir, "vite.config.js")),
        (0, fs_extra_1.pathExists)((0, path_1.join)(dir, "vite.config.ts")),
    ]);
    const anyConfigFileExists = configFilesExist.some((it) => it);
    if (!anyConfigFileExists && !(0, utils_1.findDependency)("vite", { cwd: dir, depth, omitDev: false }))
        return;
    if (npmDependency && !additionalDep)
        return;
    const { appType, publicDir: publicDirectory, plugins } = await getConfig(dir);
    if (plugin && !plugins.find(({ name }) => name === plugin))
        return;
    return { mayWantBackend: appType !== "spa", publicDirectory };
}
exports.discover = discover;
async function build(root) {
    const { build } = (0, utils_1.relativeRequire)(root, "vite");
    await (0, utils_1.warnIfCustomBuildScript)(root, exports.name, exports.DEFAULT_BUILD_SCRIPT);
    const cwd = process.cwd();
    process.chdir(root);
    await build({ root, mode: "production" });
    process.chdir(cwd);
    return { rewrites: [{ source: "**", destination: "/index.html" }] };
}
exports.build = build;
async function ɵcodegenPublicDirectory(root, dest) {
    const viteConfig = await getConfig(root);
    const viteDistPath = (0, path_1.join)(root, viteConfig.build.outDir);
    await (0, fs_extra_1.copy)(viteDistPath, dest);
}
exports.ɵcodegenPublicDirectory = ɵcodegenPublicDirectory;
async function getDevModeHandle(dir) {
    const host = new Promise((resolve, reject) => {
        const cli = (0, utils_1.getNodeModuleBin)("vite", dir);
        const serve = (0, cross_spawn_1.spawn)(cli, [], { cwd: dir });
        serve.stdout.on("data", (data) => {
            process.stdout.write(data);
            const match = data.toString().match(/(http:\/\/.+:\d+)/);
            if (match)
                resolve(match[1]);
        });
        serve.stderr.on("data", (data) => {
            process.stderr.write(data);
        });
        serve.on("exit", reject);
    });
    return (0, utils_1.simpleProxy)(await host);
}
exports.getDevModeHandle = getDevModeHandle;
async function getConfig(root) {
    const { resolveConfig } = (0, utils_1.relativeRequire)(root, "vite");
    const cwd = process.cwd();
    process.chdir(root);
    const config = await resolveConfig({ root }, "build", "production");
    process.chdir(cwd);
    return config;
}
