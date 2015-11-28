// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: '../node_modules',
    paths: {
        app: '../app',
        home: '../app/home',
        angular: 'angular/angular',
        ngRoute: 'angular-route/angular-route',
        ngResource: 'angular-resource/angular-resource'
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
requirejs(['app/main']);
