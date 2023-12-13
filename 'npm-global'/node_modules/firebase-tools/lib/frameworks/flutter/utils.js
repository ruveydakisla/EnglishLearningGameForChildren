"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.assertFlutterCliExists = void 0;
const cross_spawn_1 = require("cross-spawn");
const error_1 = require("../../error");
function assertFlutterCliExists() {
    const process = (0, cross_spawn_1.sync)("flutter", ["--version"], { stdio: "ignore" });
    if (process.status !== 0)
        throw new error_1.FirebaseError("Flutter CLI not found, follow the instructions here https://docs.flutter.dev/get-started/install before trying again.");
}
exports.assertFlutterCliExists = assertFlutterCliExists;
