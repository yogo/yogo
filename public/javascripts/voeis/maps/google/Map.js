dojo.provide("voeis.maps.google.Map");
dojo.require("dijit._Widget");
dojo.require("voeis.maps.google");

dojo.declare("voeis.maps.google.Map", dijit._Widget, {
    _map: null,
    mapType: "satellite",
    zoom: 8,
    latitude: -34.397,
    longitude: 150.644,
    width: 300,
    height: 300,
    
    _mapOptions: function() {
        return {
            mapTypeId: this.mapType,
            zoom: this.zoom,
            center: new google.maps.LatLng(this.latitude, this.longitude)
        }
    },
    _createMap: function() {
        this._map = this._map || new google.maps.Map(this.domNode, this._mapOptions());
    },
    postCreate: function() {
        dojo.when(voeis.maps.google.load(), dojo.hitch(this, "_createMap"));
    }
});
