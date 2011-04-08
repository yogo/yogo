dojo.provide("voeis.model.Site");
dojo.require("voeis.Server");
dojo.require("voeis.Model");

voeis.model.Site = voeis.Model.extend({
    projectId: null,
    initialize: function(attributes, options) {
        this.projectId = options.projectId || this.projectId;


        var server = options.server || voeis.Server.DEFAULT;
        if(this.projectId) this.objectStore = server.projectSites(this.projectId);
    }
});
