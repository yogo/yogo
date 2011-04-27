dojo.provide("yogo.xhr.csrf");

(function() {
    yogo.xhr.csrf.__loaded = false;
    yogo.xhr.csrf.__tokenFromMetaTag = function() {
        var query = dojo.query("meta[name='csrf-token']")
        return query.attr("content")[0];
    };
    yogo.xhr.csrf.getToken = function() {
        return this.__token = this.__token || this.__tokenFromMetaTag();
    };

    yogo.xhr.csrf.setToken = function(token) {
        this.__token = token;
    };

    var getToken = dojo.hitch(yogo.xhr.csrf, "getToken");
    
    yogo.xhr.csrf.csrfXhr = function(method, args, hasBody) {
        console.debug(arguments);
        var headers = {"X-CSRF-Token": getToken()}
        var oldHeaders = args.headers || {};
        dojo.mixin(headers, oldHeaders);
        var options = dojo.mixin({}, args);
        options.headers = headers;
        console.debug(options);
        return this.plainXhr.call(dojo, method, options, hasBody);
    };

    yogo.xhr.csrf.load = function() {
        if(this.__loaded) {
            return false;
        }
        
        this.plainXhr = dojo.xhr;
        
        dojo.xhr = dojo.hitch(this, "csrfXhr");

        return this.__loaded = true;
    }

})();

