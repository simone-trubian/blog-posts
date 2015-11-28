// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: '../node_modules',
    paths: {
        main: '../app/main',
        appMod: '../app/appMod',
        appCfg: '../app/appCfg',
        home: '../app/home',
        angular: 'https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min',
        ngRoute: 'https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular-route.min',
        ngResource: 'https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular-resource.min'
    },
    shim: {
        'angular': {
            exports: 'angular'
        },
        'ngRoute': {
            deps: ['angular'],
            exports: 'ngRoute'
        },
        'ngResource': {
            deps: ['angular'],
            exports: 'ngResource'
        }
    }
});

// Load the app by importing the 'main' module.
requirejs(['main']);
