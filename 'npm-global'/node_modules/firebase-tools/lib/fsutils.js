"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.readFile = exports.dirExistsSync = exports.fileExistsSync = void 0;
const fs_1 = require("fs");
const error_1 = require("./error");
function fileExistsSync(path) {
    try {
        return (0, fs_1.statSync)(path).isFile();
    }
    catch (e) {
        return false;
    }
}
exports.fileExistsSync = fileExistsSync;
function dirExistsSync(path) {
    try {
        return (0, fs_1.statSync)(path).isDirectory();
    }
    catch (e) {
        return false;
    }
}
exports.dirExistsSync = dirExistsSync;
function readFile(path) {
    try {
        return (0, fs_1.readFileSync)(path).toString();
    }
    catch (e) {
        if (e.code === "ENOENT") {
            throw new error_1.FirebaseError(`File not found: ${path}`);
        }
        throw e;
    }
}
exports.readFile = readFile;
