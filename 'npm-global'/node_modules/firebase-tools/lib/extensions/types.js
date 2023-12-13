"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ParamType = exports.FUNCTIONS_V2_RESOURCE_TYPE = exports.FUNCTIONS_RESOURCE_TYPE = exports.Visibility = exports.RegistryLaunchStage = void 0;
var RegistryLaunchStage;
(function (RegistryLaunchStage) {
    RegistryLaunchStage["EXPERIMENTAL"] = "EXPERIMENTAL";
    RegistryLaunchStage["BETA"] = "BETA";
    RegistryLaunchStage["GA"] = "GA";
    RegistryLaunchStage["DEPRECATED"] = "DEPRECATED";
    RegistryLaunchStage["REGISTRY_LAUNCH_STAGE_UNSPECIFIED"] = "REGISTRY_LAUNCH_STAGE_UNSPECIFIED";
})(RegistryLaunchStage = exports.RegistryLaunchStage || (exports.RegistryLaunchStage = {}));
var Visibility;
(function (Visibility) {
    Visibility["UNLISTED"] = "unlisted";
    Visibility["PUBLIC"] = "public";
})(Visibility = exports.Visibility || (exports.Visibility = {}));
exports.FUNCTIONS_RESOURCE_TYPE = "firebaseextensions.v1beta.function";
exports.FUNCTIONS_V2_RESOURCE_TYPE = "firebaseextensions.v1beta.v2function";
var ParamType;
(function (ParamType) {
    ParamType["STRING"] = "STRING";
    ParamType["SELECT"] = "SELECT";
    ParamType["MULTISELECT"] = "MULTISELECT";
    ParamType["SECRET"] = "SECRET";
})(ParamType = exports.ParamType || (exports.ParamType = {}));
