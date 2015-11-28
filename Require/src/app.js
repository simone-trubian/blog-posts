// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: '../node_modules',
    paths: {
        app: '../app',
        home: '../app/home',
        angular: 'angular/angular/angular',
    }
});

// Load the app by importing the 'main' module.
requirejs(['app/main']);
