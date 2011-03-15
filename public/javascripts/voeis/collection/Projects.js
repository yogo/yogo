dojo.provide("voeis.collection.Projects");
dojo.require("voeis.Server");
dojo.require("voeis.Collection");
dojo.require("voeis.model.Project");

voeis.collection.Projects = voeis.Collection.extend({
    model: voeis.model.Project,
    objectStore: voeis.Server.DEFAULT.projects()
});
