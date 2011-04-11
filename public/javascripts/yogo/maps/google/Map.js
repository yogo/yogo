dojo.provide("yogo.maps.google.Map");
dojo.require("dijit._Widget");
dojo.require("yogo.maps.google");

dojo.declare("yogo.maps.google.Map", dijit._Widget, {
    _map: null,
    _mapDfd: null,
    mapType: "satellite",
    zoom: 1,
    latitude: 0,
    longitude: 0,
    
    constructor: function() {
        this._mapDfd = new dojo.Deferred();
    },
    _mapOptions: function() {
        return {
            mapTypeId: this.mapType,
            zoom: this.zoom,
            center: new google.maps.LatLng(this.latitude, this.longitude)
        }
    },
    _createMap: function() {
        this._map = this._map || new google.maps.Map(this.domNode, this._mapOptions());
        this._mapDfd.resolve(this._map);
    },
    postCreate: function() {
        dojo.when(yogo.maps.google.load(), dojo.hitch(this, "_createMap"));
    }
});
