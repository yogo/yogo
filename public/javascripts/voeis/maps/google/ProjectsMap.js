dojo.provide("voeis.maps.google.ProjectsMap");
dojo.require("voeis.maps.google.DataMap");
dojo.require("dojo.DeferredList");


dojo.declare("voeis.maps.google.ProjectsMap", voeis.maps.google.DataMap, {
    createMarkers: function() {
        var dfd = new dojo.Deferred();

        var allSites = dojo.when(this.items(), dojo.hitch(this, function(projects){
            console.log("mapping projects -> sites")
            console.debug(projects);
            var projectSites = dojo.map(projects, function(p){
                return p.sites();
            }, this);
            return new dojo.DeferredList(projectSites);
        }));

        
        var flatSites = dojo.when(allSites, dojo.hitch(this, function(dfdList) {
            console.log("flattening sites array");
            console.debug(dfdList);
            var flat = []
            
            dojo.forEach(dfdList, function(s){
                console.debug(s);
                if(s[1]) {
                    flat = flat.concat(s[1]);
                }
            });
            
            return flat;
        }));

        dojo.when(flatSites, dojo.hitch(this, function(sites){
            console.log("mapping sites -> markers");
            console.debug(sites);
            var markers = dojo.map(sites, dojo.hitch(this, "markerFromItem"));
            console.debug(markers);
            dfd.resolve(markers);
        }));

        
        return dfd;
    },

    markerFromItem: function(item) {
        var marker = this.inherited(arguments);
        marker._voeisSite = item;

        var markerClick = dojo.hitch(this, function(evt){
            this._siteClick(item);
        });

        google.maps.event.addListener(marker, 'click', markerClick);
        return marker;
    },

    _siteClick: function(site) {
        dojo.publish("voeis/project/site/selected", [site.projectId(), site.id]);
    }
});
