dojo.provide("voeis.store.Sites");
dojo.require("dojo.store.util.QueryResults");


voeis.store.Sites = function(store, projectId, server) {
    if(store._sitesServer && store._projectId) {
        return store;
    }
    store._sitesServer = server;
    store._projectId = projectId;
    

    var proto = {
        projectId: function() {
            return store._projectId;
        }
    };

    var extendedObject = function(object) {
        if(typeof object.projectId !== 'function') {
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
        var dfd = new dojo.Deferred();
        
        dojo.when(origQuery.apply(this, arguments).map(extendedObject), function(results) {
            dfd.resolve(results);
        });
        
        return dojo.store.util.QueryResults(dfd);
    }


    return store;
};
