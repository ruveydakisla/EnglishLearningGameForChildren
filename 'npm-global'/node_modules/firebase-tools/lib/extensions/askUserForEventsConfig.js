"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.askForEventArcLocation = exports.askShouldCollectEventsConfig = exports.askForAllowedEventTypes = exports.askForEventsConfig = exports.checkAllowedEventTypesResponse = void 0;
const prompt_1 = require("../prompt");
const extensionsApi = require("../extensions/extensionsApi");
const utils = require("../utils");
const clc = require("colorette");
const logger_1 = require("../logger");
const marked_1 = require("marked");
function checkAllowedEventTypesResponse(response, validEvents) {
    const validEventTypes = validEvents.map((e) => e.type);
    if (response.length === 0) {
        return false;
    }
    for (const e of response) {
        if (!validEventTypes.includes(e)) {
            utils.logWarning(`Unexpected event type '${e}' was configured to be emitted. This event type is not part of the extension spec.`);
            return false;
        }
    }
    return true;
}
exports.checkAllowedEventTypesResponse = checkAllowedEventTypesResponse;
async function askForEventsConfig(events, projectId, instanceId) {
    var _a, _b;
    logger_1.logger.info(`\n${clc.bold("Enable Events")}: ${(0, marked_1.marked)("If you enable events, you can write custom event handlers ([https://firebase.google.com/docs/extensions/install-extensions#eventarc](https://firebase.google.com/docs/extensions/install-extensions#eventarc)) that respond to these events.\n\nYou can always enable or disable events later. Events will be emitted via Eventarc. Fees apply ([https://cloud.google.com/eventarc/pricing](https://cloud.google.com/eventarc/pricing)).")}`);
    if (!(await askShouldCollectEventsConfig())) {
        return undefined;
    }
    let existingInstance;
    try {
        existingInstance = instanceId
            ? await extensionsApi.getInstance(projectId, instanceId)
            : undefined;
    }
    catch (_c) {
    }
    const preselectedTypes = (_a = existingInstance === null || existingInstance === void 0 ? void 0 : existingInstance.config.allowedEventTypes) !== null && _a !== void 0 ? _a : [];
    const oldLocation = (_b = existingInstance === null || existingInstance === void 0 ? void 0 : existingInstance.config.eventarcChannel) === null || _b === void 0 ? void 0 : _b.split("/")[3];
    const location = await askForEventArcLocation(oldLocation);
    const channel = `projects/${projectId}/locations/${location}/channels/firebase`;
    const allowedEventTypes = await askForAllowedEventTypes(events, preselectedTypes);
    return { channel, allowedEventTypes };
}
exports.askForEventsConfig = askForEventsConfig;
async function askForAllowedEventTypes(eventDescriptors, preselectedTypes) {
    let valid = false;
    let response = [];
    const eventTypes = eventDescriptors.map((e, index) => ({
        checked: false,
        name: `${index + 1}. ${e.type}\n   ${e.description}`,
        value: e.type,
    }));
    while (!valid) {
        response = await (0, prompt_1.promptOnce)({
            name: "selectedEventTypesInput",
            type: "checkbox",
            default: preselectedTypes !== null && preselectedTypes !== void 0 ? preselectedTypes : [],
            message: `Please select the events [${eventTypes.length} types total] that this extension is permitted to emit. ` +
                "You can implement your own handlers that trigger when these events are emitted to customize the extension's behavior. ",
            choices: eventTypes,
            pageSize: 20,
        });
        valid = checkAllowedEventTypesResponse(response, eventDescriptors);
    }
    return response.filter((e) => e !== "");
}
exports.askForAllowedEventTypes = askForAllowedEventTypes;
async function askShouldCollectEventsConfig() {
    return (0, prompt_1.promptOnce)({
        type: "confirm",
        name: "shouldCollectEvents",
        message: `Would you like to enable events?`,
        default: false,
    });
}
exports.askShouldCollectEventsConfig = askShouldCollectEventsConfig;
async function askForEventArcLocation(preselectedLocation) {
    let valid = false;
    const allowedRegions = ["us-central1", "us-west1", "europe-west4", "asia-northeast1"];
    let location = "";
    while (!valid) {
        location = await (0, prompt_1.promptOnce)({
            name: "input",
            type: "list",
            default: preselectedLocation !== null && preselectedLocation !== void 0 ? preselectedLocation : "us-central1",
            message: "Which location would you like the Eventarc channel to live in? We recommend using the default option. A channel location that differs from the extension's Cloud Functions location can incur egress cost.",
            choices: allowedRegions.map((e) => ({ checked: false, value: e })),
        });
        valid = allowedRegions.includes(location);
        if (!valid) {
            utils.logWarning(`Unexpected EventArc region '${location}' was specified. Allowed regions: ${allowedRegions.join(", ")}`);
        }
    }
    return location;
}
exports.askForEventArcLocation = askForEventArcLocation;
