dojo.provide("voeis.MenuLink");
dojo.require("dijit.MenuItem");

dojo.declare("voeis.MenuLink", dijit.MenuItem, {
    href: "",
    onClick: function(evt) {
        if(this.href) {
            window.location = this.href;
        }
    }
});
