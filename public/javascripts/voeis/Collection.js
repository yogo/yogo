dojo.provide("voeis.Collection");
dojo.require("voeis.Server");
dojo.require("underscore", true);
dojo.require("backbone", true);

voeis.Collection = Backbone.Collection.extend({
    objectStore: null,
    sync: voeis.Server.BackboneSync
});
