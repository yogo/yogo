dojo.provide("voeis.maps.google.MapMarkers");
dojo.require("voeis.maps.google");


voeis.maps.google.load();

voeis.maps.google.MapMarkers = function(store, options) {
    if(store._mapMarkerOptions) {
        return store;
    }

    store._mapMarkerOptions = options || {};

    function createMarker(object, options, async) {
        var defaultOptions = {
            latitude: function(object) {
                return object.latitude;
            },
            longitude: function(object) {
                return object.longitude;
            },
            title: function(object) {
                return object.title || object.name;
            }
        };
        
        options = dojo.delegate(defaultOptions, options);
        
        
        var markerOptions = dojo.delegate(object,{});
        markerOptions['position'] = new google.maps.LatLng(options.latitude(object), options.longitude(object));
        markerOptions['title'] = options.title(object);
        
        return new google.maps.Marker(markerOptions);
        
    }

    var proto = {
        toMarker: function() {
            return createMarker(this, store._mapMarkerOptions);
        }
    };

    var extendedObject = function(object) {
        if(typeof object.toMarker !== 'function') {
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
        return origQuery.apply(this, arguments).map(extendedObject);
    }

    return store;
};

