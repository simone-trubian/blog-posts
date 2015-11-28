define(['app/app.config',
        'angular',
        'ngRoute',
        'ngResource',
        'home/home.controller'
    ],

    function(config,
             angular,
             ngRoute,
             ngResource,
             HomeController
             ) {

    var app = angular.module('requireApp', ['ngRoute','ngResource']);

    app.config(config);
    app.controller('HomeController', HomeController);
});
