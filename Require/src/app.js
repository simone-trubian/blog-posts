// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: '../node_modules',
    paths: {
        main: '../app/main',
        appMod: '../app/appMod',
        appCfg: '../app/appCfg',
        home: '../app/home',
        angular: 'angular/angular',
        ngState: 'angular-ui-router/build/angular-ui-router',
        ngResource: 'angular-resource/angular-resource'
    },
    shim: {
        'angular': {
            exports: 'angular'
        },
        'ngResource': {
            deps: ['angular'],
            exports: 'ngResource'
        },
        'ngState': {
            deps: ['angular'],
            exports: 'ngState'
        }
    }
});

// Load the app by importing the 'main' module.
requirejs(['main']);
