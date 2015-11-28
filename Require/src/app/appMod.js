'use strict';

define(['appCfg',
        'angular',
        'ngState',
        'ngResource',
        'home/homeCtrl'
    ],

    function(config,
             angular,
             ngState,
             ngResource,
             HomeController
             ) {

    var dependencies = [
        'ui.router',
        'ngResource'
    ];

    angular
        .module('requireApp', dependencies)
        .config(config)
        .controller('HomeController', HomeController)
});
