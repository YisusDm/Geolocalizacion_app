'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var tslib = require('tslib');
var core = require('@ionic-native/core');
var core$1 = require('@angular/core');

var BackgroundFetch = /** @class */ (function (_super) {
    tslib.__extends(BackgroundFetch, _super);
    function BackgroundFetch() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    BackgroundFetch.prototype.configure = function (config) { return core.cordova(this, "configure", { "callbackOrder": "reverse" }, arguments); };
    BackgroundFetch.prototype.start = function () { return core.cordova(this, "start", {}, arguments); };
    BackgroundFetch.prototype.stop = function () { return core.cordova(this, "stop", {}, arguments); };
    BackgroundFetch.prototype.finish = function (taskId) { return core.cordova(this, "finish", { "sync": true }, arguments); };
    BackgroundFetch.prototype.status = function () { return core.cordova(this, "status", {}, arguments); };
    BackgroundFetch.pluginName = "BackgroundFetch";
    BackgroundFetch.plugin = "cordova-plugin-background-fetch";
    BackgroundFetch.pluginRef = "BackgroundFetch";
    BackgroundFetch.repo = "https://github.com/transistorsoft/cordova-plugin-background-fetch";
    BackgroundFetch.platforms = ["iOS"];
    BackgroundFetch.decorators = [
        { type: core$1.Injectable }
    ];
    return BackgroundFetch;
}(core.IonicNativePlugin));

exports.BackgroundFetch = BackgroundFetch;
