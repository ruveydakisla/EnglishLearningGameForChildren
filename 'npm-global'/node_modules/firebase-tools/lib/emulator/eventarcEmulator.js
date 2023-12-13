"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EventarcEmulator = void 0;
const express = require("express");
const constants_1 = require("./constants");
const types_1 = require("./types");
const utils_1 = require("../utils");
const emulatorLogger_1 = require("./emulatorLogger");
const registry_1 = require("./registry");
const error_1 = require("../error");
const eventarcEmulatorUtils_1 = require("./eventarcEmulatorUtils");
class EventarcEmulator {
    constructor(args) {
        this.args = args;
        this.logger = emulatorLogger_1.EmulatorLogger.forEmulator(types_1.Emulators.EVENTARC);
        this.customEvents = {};
    }
    createHubServer() {
        const registerTriggerRoute = `/emulator/v1/projects/:project_id/triggers/:trigger_name(*)`;
        const registerTriggerHandler = (req, res) => {
            const projectId = req.params.project_id;
            const triggerName = req.params.trigger_name;
            if (!projectId || !triggerName) {
                const error = "Missing project ID or trigger name.";
                this.logger.log("ERROR", error);
                res.status(400).send({ error });
                return;
            }
            const bodyString = req.rawBody.toString();
            const substituted = bodyString.replaceAll("${PROJECT_ID}", projectId);
            const body = JSON.parse(substituted);
            const eventTrigger = body.eventTrigger;
            if (!eventTrigger) {
                const error = `Missing event trigger for ${triggerName}.`;
                this.logger.log("ERROR", error);
                res.status(400).send({ error });
                return;
            }
            const key = `${eventTrigger.eventType}-${eventTrigger.channel}`;
            this.logger.logLabeled("BULLET", "eventarc", `Registering custom event trigger for ${key} with trigger name ${triggerName}.`);
            const customEventTriggers = this.customEvents[key] || [];
            customEventTriggers.push({ projectId, triggerName, eventTrigger });
            this.customEvents[key] = customEventTriggers;
            res.status(200).send({ res: "OK" });
        };
        const publishEventsRoute = `/projects/:project_id/locations/:location/channels/:channel::publishEvents`;
        const publishEventsHandler = (req, res) => {
            const channel = `projects/${req.params.project_id}/locations/${req.params.location}/channels/${req.params.channel}`;
            const body = JSON.parse(req.rawBody.toString());
            for (const event of body.events) {
                if (!event.type) {
                    res.sendStatus(400);
                    return;
                }
                this.logger.log("INFO", `Received custom event at channel ${channel}: ${JSON.stringify(event, null, 2)}`);
                this.triggerCustomEventFunction(channel, event);
            }
            res.sendStatus(200);
        };
        const dataMiddleware = (req, _, next) => {
            const chunks = [];
            req.on("data", (chunk) => {
                chunks.push(chunk);
            });
            req.on("end", () => {
                req.rawBody = Buffer.concat(chunks);
                next();
            });
        };
        const hub = express();
        hub.post([registerTriggerRoute], dataMiddleware, registerTriggerHandler);
        hub.post([publishEventsRoute], dataMiddleware, publishEventsHandler);
        hub.all("*", (req, res) => {
            this.logger.log("DEBUG", `Eventarc emulator received unknown request at path ${req.path}`);
            res.sendStatus(404);
        });
        return hub;
    }
    async triggerCustomEventFunction(channel, event) {
        if (!registry_1.EmulatorRegistry.isRunning(types_1.Emulators.FUNCTIONS)) {
            this.logger.log("INFO", "Functions emulator not found. This should not happen.");
            return Promise.reject();
        }
        const key = `${event.type}-${channel}`;
        const triggers = this.customEvents[key] || [];
        return await Promise.all(triggers
            .filter((trigger) => !trigger.eventTrigger.eventFilters ||
            this.matchesAll(event, trigger.eventTrigger.eventFilters))
            .map((trigger) => registry_1.EmulatorRegistry.client(types_1.Emulators.FUNCTIONS)
            .request({
            method: "POST",
            path: `/functions/projects/${trigger.projectId}/triggers/${trigger.triggerName}`,
            body: JSON.stringify((0, eventarcEmulatorUtils_1.cloudEventFromProtoToJson)(event)),
            responseType: "stream",
            resolveOnHTTPError: true,
        })
            .then((res) => {
            if (res.status >= 400) {
                throw new error_1.FirebaseError(`Received non-200 status code: ${res.status}`);
            }
        })
            .catch((err) => {
            this.logger.log("ERROR", `Failed to trigger Functions emulator for ${trigger.triggerName}: ${err}`);
        })));
    }
    matchesAll(event, eventFilters) {
        return Object.entries(eventFilters).every(([key, value]) => {
            var _a, _b;
            let attr = (_a = event[key]) !== null && _a !== void 0 ? _a : event.attributes[key];
            if (typeof attr === "object" && !Array.isArray(attr)) {
                attr = (_b = attr.ceTimestamp) !== null && _b !== void 0 ? _b : attr.ceString;
            }
            return attr === value;
        });
    }
    async start() {
        const { host, port } = this.getInfo();
        const server = this.createHubServer().listen(port, host);
        this.destroyServer = (0, utils_1.createDestroyer)(server);
        return Promise.resolve();
    }
    async connect() {
        return Promise.resolve();
    }
    async stop() {
        if (this.destroyServer) {
            await this.destroyServer();
        }
    }
    getInfo() {
        const host = this.args.host || constants_1.Constants.getDefaultHost();
        const port = this.args.port || constants_1.Constants.getDefaultPort(types_1.Emulators.EVENTARC);
        return {
            name: this.getName(),
            host,
            port,
        };
    }
    getName() {
        return types_1.Emulators.EVENTARC;
    }
}
exports.EventarcEmulator = EventarcEmulator;
