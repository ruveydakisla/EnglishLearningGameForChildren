"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthBlockingService = void 0;
const backend = require("../backend");
const identityPlatform = require("../../../gcp/identityPlatform");
const events = require("../../../functions/events");
const error_1 = require("../../../error");
const utils_1 = require("../../../utils");
const index_1 = require("./index");
class AuthBlockingService {
    constructor() {
        this.name = "authblocking";
        this.api = "identitytoolkit.googleapis.com";
        this.triggerQueue = Promise.resolve();
        this.ensureTriggerRegion = index_1.noop;
    }
    validateTrigger(endpoint, wantBackend) {
        if (!backend.isBlockingTriggered(endpoint)) {
            return;
        }
        const blockingEndpoints = backend
            .allEndpoints(wantBackend)
            .filter((ep) => backend.isBlockingTriggered(ep));
        if (blockingEndpoints.find((ep) => ep.blockingTrigger.eventType === endpoint.blockingTrigger.eventType &&
            ep.id !== endpoint.id)) {
            throw new error_1.FirebaseError(`Can only create at most one Auth Blocking Trigger for ${endpoint.blockingTrigger.eventType} events`);
        }
    }
    configChanged(newConfig, config) {
        var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l, _m, _o, _p;
        if (((_b = (_a = newConfig.triggers) === null || _a === void 0 ? void 0 : _a.beforeCreate) === null || _b === void 0 ? void 0 : _b.functionUri) !==
            ((_d = (_c = config.triggers) === null || _c === void 0 ? void 0 : _c.beforeCreate) === null || _d === void 0 ? void 0 : _d.functionUri) ||
            ((_f = (_e = newConfig.triggers) === null || _e === void 0 ? void 0 : _e.beforeSignIn) === null || _f === void 0 ? void 0 : _f.functionUri) !== ((_h = (_g = config.triggers) === null || _g === void 0 ? void 0 : _g.beforeSignIn) === null || _h === void 0 ? void 0 : _h.functionUri)) {
            return true;
        }
        if (!!((_j = newConfig.forwardInboundCredentials) === null || _j === void 0 ? void 0 : _j.accessToken) !==
            !!((_k = config.forwardInboundCredentials) === null || _k === void 0 ? void 0 : _k.accessToken) ||
            !!((_l = newConfig.forwardInboundCredentials) === null || _l === void 0 ? void 0 : _l.idToken) !==
                !!((_m = config.forwardInboundCredentials) === null || _m === void 0 ? void 0 : _m.idToken) ||
            !!((_o = newConfig.forwardInboundCredentials) === null || _o === void 0 ? void 0 : _o.refreshToken) !==
                !!((_p = config.forwardInboundCredentials) === null || _p === void 0 ? void 0 : _p.refreshToken)) {
            return true;
        }
        return false;
    }
    async registerTriggerLocked(endpoint) {
        const newBlockingConfig = await identityPlatform.getBlockingFunctionsConfig(endpoint.project);
        const oldBlockingConfig = (0, utils_1.cloneDeep)(newBlockingConfig);
        if (endpoint.blockingTrigger.eventType === events.v1.BEFORE_CREATE_EVENT) {
            newBlockingConfig.triggers = Object.assign(Object.assign({}, newBlockingConfig.triggers), { beforeCreate: {
                    functionUri: endpoint.uri,
                } });
        }
        else {
            newBlockingConfig.triggers = Object.assign(Object.assign({}, newBlockingConfig.triggers), { beforeSignIn: {
                    functionUri: endpoint.uri,
                } });
        }
        newBlockingConfig.forwardInboundCredentials = Object.assign(Object.assign({}, oldBlockingConfig.forwardInboundCredentials), endpoint.blockingTrigger.options);
        if (!this.configChanged(newBlockingConfig, oldBlockingConfig)) {
            return;
        }
        await identityPlatform.setBlockingFunctionsConfig(endpoint.project, newBlockingConfig);
    }
    registerTrigger(ep) {
        if (!backend.isBlockingTriggered(ep)) {
            return Promise.resolve();
        }
        this.triggerQueue = this.triggerQueue.then(() => this.registerTriggerLocked(ep));
        return this.triggerQueue;
    }
    async unregisterTriggerLocked(endpoint) {
        var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k;
        const blockingConfig = await identityPlatform.getBlockingFunctionsConfig(endpoint.project);
        if (endpoint.uri !== ((_b = (_a = blockingConfig.triggers) === null || _a === void 0 ? void 0 : _a.beforeCreate) === null || _b === void 0 ? void 0 : _b.functionUri) &&
            endpoint.uri !== ((_d = (_c = blockingConfig.triggers) === null || _c === void 0 ? void 0 : _c.beforeSignIn) === null || _d === void 0 ? void 0 : _d.functionUri)) {
            return;
        }
        if (endpoint.uri === ((_f = (_e = blockingConfig.triggers) === null || _e === void 0 ? void 0 : _e.beforeCreate) === null || _f === void 0 ? void 0 : _f.functionUri)) {
            (_g = blockingConfig.triggers) === null || _g === void 0 ? true : delete _g.beforeCreate;
        }
        if (endpoint.uri === ((_j = (_h = blockingConfig.triggers) === null || _h === void 0 ? void 0 : _h.beforeSignIn) === null || _j === void 0 ? void 0 : _j.functionUri)) {
            (_k = blockingConfig.triggers) === null || _k === void 0 ? true : delete _k.beforeSignIn;
        }
        await identityPlatform.setBlockingFunctionsConfig(endpoint.project, blockingConfig);
    }
    unregisterTrigger(ep) {
        if (!backend.isBlockingTriggered(ep)) {
            return Promise.resolve();
        }
        this.triggerQueue = this.triggerQueue.then(() => this.unregisterTriggerLocked(ep));
        return this.triggerQueue;
    }
}
exports.AuthBlockingService = AuthBlockingService;
