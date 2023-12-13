"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ensureFirestoreTriggerRegion = void 0;
const firestore = require("../../../gcp/firestore");
const error_1 = require("../../../error");
async function ensureFirestoreTriggerRegion(endpoint) {
    var _a;
    const db = await firestore.getDatabase(endpoint.project, ((_a = endpoint.eventTrigger.eventFilters) === null || _a === void 0 ? void 0 : _a.database) || "(default)");
    const dbRegion = db.locationId;
    if (!endpoint.eventTrigger.region) {
        endpoint.eventTrigger.region = dbRegion;
    }
    if (endpoint.eventTrigger.region !== dbRegion) {
        throw new error_1.FirebaseError("A firestore trigger location must match the firestore database region.");
    }
}
exports.ensureFirestoreTriggerRegion = ensureFirestoreTriggerRegion;
