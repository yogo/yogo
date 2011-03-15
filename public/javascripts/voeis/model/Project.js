dojo.provide("voeis.model.Project");
dojo.require("voeis.Server");
dojo.require("voeis.Model");
dojo.require("voeis.collection.Sites");

voeis.model.Project = voeis.Model.extend({
    objectStore: voeis.Server.DEFAULT.projects(),
    sites: function(){
        this._sites = this._sites || new voeis.collection.Sites(null, {projectId: this.id})
        return this._sites;
    }
});
