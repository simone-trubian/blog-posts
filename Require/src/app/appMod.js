'use strict';

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

    var dependencies = [
        'ngRoute',
        'ngResource'
    ];

    angular
        .module('requireApp', dependencies)
        .config(config)
        .controller('HomeController', HomeController)
});
