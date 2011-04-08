dojo.provide("voeis.maps.google.DataMap");
dojo.require("voeis.maps.google.Map");
dojo.require("dojo.store.Observable");
dojo.require("dojo.store.Memory");

dojo.declare("voeis.maps.google.DataMap", voeis.maps.google.Map, {
    store: null,
    query: null,
    
    markerIcon: "",
    
    constructor: function() {
        this._markers = [];
        this.setStore(this.store || new dojo.store.Memory());
    },
    setStore: function(store) {
        if(typeof store.notify !== 'function') {
            dojo.store.Observable(store);
        }
        if(this.store !== store) {
            this.store = store;
        }
        this.loadData().refresh();
    },
    items: function() {
        this._items || this.loadData();
        return this._items;
    },
    loadData: function() {
        this._itemsListener && this._itemsListener.cancel();
        this._items = this.store.query();
        this._itemsListener = this._items.observe(dojo.hitch(this, "_itemsChanged"), true);
        return this;
    },
    refresh: function() {
        this.loadData();
        dojo.when(this._mapDfd, dojo.hitch(this, function(){
            this.updateMarkers(true);
        }));
        return this;
    },
    beginItemChanges: function() {
        this._itemsChanging = true;
        return this;
    },
    endItemChanges: function() {
        this._itemsChanging = false;
        this._itemsChanged();
        return this;
    },
    _itemsChanged: function(object, removedFrom, insertedAt) {
        // this should be made more efficient
        console.log("_itemsChanged");
        console.debug(arguments);
        if(!this._itemsChanging) {
            this.updateMarkers(true);
        }
    },
    itemTitle: function(item) {
        return item.title || item.name;
    },
    itemPosition: function(item) {
        return new google.maps.LatLng(item.latitude, item.longitude);
    },
    markerFromItem: function(item) {
        return new google.maps.Marker({
            title: this.itemTitle(item),
            position: this.itemPosition(item),
            icon: this.markerIcon
        });
    },
    markerBounds: function(markers) {
        var currMarkers = markers || this._markers;
        var bounds;

        if(currMarkers.length > 0) {
            bounds = new google.maps.LatLngBounds();
        }
        else {
            var ne = new google.maps.LatLng(50, -50);
            var sw = new google.maps.LatLng(18, -130);
            bounds = new google.maps.LatLngBounds(sw, ne);
        }
        
        dojo.forEach(currMarkers, function(marker) {
            console.debug(marker);
            bounds.extend(marker.getPosition());
        });
        return bounds;
    },
    fitBounds: function(bounds) {
        this._map.fitBounds(bounds || this.markerBounds());
    },
    createMarkers: function() {
        return items.map(dojo.hitch(this, "markerFromItem"));
    },
    updateMarkers: function(updateBounds) {
        console.log("getting items");
        var items = this.items();
        console.log("mapping items to markers");
        var newMarkers = this.createMarkers();
        
        dojo.when(newMarkers, dojo.hitch(this, function(markers) {
            console.debug(markers);
            console.log("removing old markers");
            dojo.forEach(this._markers, function(marker) {
                marker.setMap(null); // remove the marker
            }, this);
            
            this._markers = [];
            
            console.log("adding new markers");

            dojo.forEach(markers, function(marker) {
                console.debug(marker);
                this._markers.push(marker);                
                marker.setMap(this._map);
            }, this);
            
            if(updateBounds) {
                this.fitBounds();
            }
        }));
    }
});
