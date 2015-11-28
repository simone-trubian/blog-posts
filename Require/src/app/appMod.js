define(['appCfg',
        'angular',
        'ngRoute',
        'ngResource',
        'home/homeCtrl'
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
