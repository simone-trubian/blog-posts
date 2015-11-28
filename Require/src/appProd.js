// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: '../node_modules',
    paths: {
        main: '../app/main',
        appMod: '../app/appMod',
        appCfg: '../app/appCfg',
        home: '../app/home',
        angular: 'https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min',
        ngState:'https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.15/angular-ui-router.min',
        ngResource: 'https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular-resource.min'
    },
    shim: {
        'angular': {
            exports: 'angular'
        },
        'ngState': {
            deps: ['angular'],
            exports: 'ngState'
        },
        'ngResource': {
            deps: ['angular'],
            exports: 'ngResource'
        }
    }
});

// Load the app by importing the 'main' module.
requirejs(['main']);
