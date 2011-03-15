dojo.provide("voeis.Server");
dojo.require("dojo.store.JsonRest");
dojo.require("dojo.data.ObjectStore");

dojo.declare("voeis.Server", null, {
    constructor: function(args){
        this.baseUrl = "";
        dojo.mixin(this, args);
    },
    projectsPath: function() {
        return [this.baseUrl, "projects"].join("/");
    },
    projectPath: function(id) {
        return [this.projectsPath(), id].join("/");
    },
    projectSitesPath: function(projectId) {
        return [this.projectPath(projectId), "sites"].join("/");
    },
    projectSitePath: function(projectId, siteId) {
        return [this.projectSitesPath(projectId), siteId].join("/");
    },

    /** Stores **/
    projects: function() {
        this._projects = this._projects ||  new dojo.store.JsonRest({target:this.projectsPath() + "/"});
        return this._projects;
    },
    projectsDataStore: function() {
        return new dojo.data.ObjectStore({objectStore:this.projectStore()});
    },

    projectSites: function(projectId) {
        this._projectSites = this._projectSites ||new dojo.store.JsonRest({target:this.projectSitesPath(projectId) + "/"});
        return this._projectSites;
    },
    projectSitesDataStore: function(projectId) {
        return new dojo.data.ObjectStore({objectStore:this.projectSiteStore(projectId)});
    }

});

voeis.Server.DEFAULT = new voeis.Server();

voeis.Server.BackboneSync = function(method, model, success, error) {
    var methodFor = {
        'create': function(model) { return 'add'; },
        'update': function(model) { return 'put'; },
        'read': function(model) { 
            return (model instanceof Backbone.Collection) ? 'query' : 'get'
        },
        'delete': function(model) { return 'delete' }
    };

    var argsFor = {
        'add': function(model) {
            return [model.toJSON()];
        },
        'put': function(model) {
            return [model.id, model.toJSON()];
        },
        'read': function(model) {
            return [model.id];
        },
        'delete': function(model) {
            return [model.id];
        },
        'query': function(model) {
            return [model.query || ""];
        }
    };

    var objectStore = model.objectStore;

    var storeMethod = methodFor[method](model);
    var storeArgs = argsFor[storeMethod](model);
    
    var result = objectStore[storeMethod].apply(objectStore, storeArgs);
    result.addCallbacks(success, error);
}
