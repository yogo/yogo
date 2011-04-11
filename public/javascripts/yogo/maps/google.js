dojo.provide("yogo.maps.google");

(function(){
    var callbackCount = 0;
    var loaded = false;
    var loading = false;
    var deferred = new dojo.Deferred();
    
    yogo.maps.google.load = function(options) {
        var options = options || {};
        var useSensor = options['sensor'] || false;
        var force = options['force'] || false;
        
        if(force || (!loaded && !loading)) {
            loading = true;
            var globalCallbackName = "__voeis_maps_google_load_" + callbackCount;
            window[globalCallbackName] = function(){ 
                loaded = true;
                loading = false;
                delete window[globalCallbackName];
                deferred.callback(google.maps);
            }
            callbackCount += 1;
            
            var script = document.createElement("script");
            script.type = "text/javascript";
            script.src = "http://maps.google.com/maps/api/js?sensor=" + useSensor + "&callback=" + globalCallbackName;
            
            dojo.addOnLoad(function() {
                document.body.appendChild(script);
            });
        }
        
        return deferred;
    };
})();
