dojo.provide("yogo.ui.MenuLink");
dojo.require("dijit.MenuItem");

dojo.declare("yogo.ui.MenuLink", dijit.MenuItem, {
    href: "",
    onClick: function(evt) {
        if(this.href) {
            window.location = this.href;
        }
    }
});
