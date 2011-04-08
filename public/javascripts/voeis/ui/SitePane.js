dojo.provide("voeis.ui.SitePane");
dojo.require("dijit.layout.ContentPane");
dojo.require("voeis.Server");

dojo.declare("voeis.ui.SitePane", dijit.layout.ContentPane, {
    siteId: "",
    projectId: "",
    closable: true,
    
    ioArgs: {
        headers: {
            "Accept": "text/html"
        }
    },
    
    constructor: function() {
        this.server = this.server || voeis.Server.DEFAULT;
        this.watch("siteId", dojo.hitch(this, "_siteUpdated"));
    },
    
    _siteUpdated: function() {
        this.set("title", "Loading...");
        this.set("href", this.server.projectSitePath(this.projectId, this.siteId));
        dojo.when(this.site(), dojo.hitch(this, function(site) {
            this.set("title", site.name);
        }));
    },

    site: function() {
        var server = this.server;
        this._siteStore = this._siteStore || server.projectSites(this.projectId);
        return this._siteStore.get(this.siteId);
    }

});

voeis.ui.SitePane._project = voeis.ui.SitePane._project || {};

