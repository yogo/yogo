dojo.provide("voeis.Model");
dojo.require("voeis.Server");
dojo.require("underscore", true);
dojo.require("backbone", true);

voeis.Model = Backbone.Model.extend({
    objectStore: null,
    sync: voeis.Server.BackboneSync
});
