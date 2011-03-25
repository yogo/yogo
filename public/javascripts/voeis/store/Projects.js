dojo.provide("voeis.store.Projects");

voeis.store.Projects = function(store, server) {
    if(store._projectsServer) {
        return store;
    }
    store._projectsServer = server;
    
    function getSites(project, options) {
        var sites = server.projectSites(store.getIdentity(project));
        return sites.query("", options);
    }

    store.getChildren = getSites;

    var proto = {
        sites: function() {
            return getSites(this);
        }
    };

    var extendedObject = function(object) {
        if(typeof object.sites !== 'function') {
            return dojo.delegate(proto, object);
        }
        return object;
    };

    var enhanceObject = function(object) {
        var dfd = new dojo.Deferred();
        dojo.when(object, function(object) {
            dfd.resolve(extendedObject(object));
        });
        return dfd;
    };
    
    var origGet = store.get;
    store.get = function() {
        var res = origGet.apply(this, arguments);
        return enhanceObject(res);
    };

    var origPut = store.put;
    store.put = function() {
        var res = origPut.apply(this, arguments);
        return enhanceObject(res);
    };

    var origQuery = store.query;
    store.query = function() {
        return origQuery.apply(this, arguments).map(enhanceObject);
    }



    var origPut = store
    return store;
};
