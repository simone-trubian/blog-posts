'use strict';

define(['appCfg',
        'angular',
        'ngState',
        'ngResource',
        'home/homeCtrl',
        'home/homeSrv'
    ],

    function(config,
             angular,
             ngState,
             ngResource,
             HomeCtrl,
             HomeSrv
             ) {

    var dependencies = [
        'ui.router',
        'ngResource'
    ];

    angular
        .module('requireApp', dependencies)
        .config(config)
        .controller('HomeCtrl', HomeCtrl)
        .factory('HomeSrv', HomeSrv)
});
