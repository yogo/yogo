dojo.provide("voeis.collection.Sites");
dojo.require("voeis.Server");
dojo.require("voeis.Collection");
dojo.require("voeis.model.Site");

voeis.collection.Sites = voeis.Collection.extend({
    model: voeis.model.Site,
    projectId: null,
    initialize: function(models, options) {
        this.projectId = options.projectId || this.projectId;

        var server = options.server || voeis.Server.DEFAULT;
        this.objectStore = server.projectSites(this.projectId);
    },
    create: function() {
        var model = voeis.Collection.prototype.apply(this, arguments);
        model.projectId = this.projectId;
        model.objectStore = this.objectStore;
        return model;
    }
})
