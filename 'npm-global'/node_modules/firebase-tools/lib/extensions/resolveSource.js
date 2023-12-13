"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getExtensionRegistry = void 0;
const apiv2_1 = require("../apiv2");
const api_1 = require("../api");
const EXTENSIONS_REGISTRY_ENDPOINT = "/extensions.json";
async function getExtensionRegistry(onlyFeatured = false) {
    var _a;
    const client = new apiv2_1.Client({ urlPrefix: api_1.firebaseExtensionsRegistryOrigin });
    const res = await client.get(EXTENSIONS_REGISTRY_ENDPOINT);
    const extensions = res.body.mods || {};
    if (onlyFeatured) {
        const featuredList = new Set(((_a = res.body.featured) === null || _a === void 0 ? void 0 : _a.discover) || []);
        const filteredExtensions = {};
        for (const [name, extension] of Object.entries(extensions)) {
            if (featuredList.has(name)) {
                filteredExtensions[name] = extension;
            }
        }
        return filteredExtensions;
    }
    return extensions;
}
exports.getExtensionRegistry = getExtensionRegistry;
