// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: '../node_modules',
    paths: {
        main: '../app/main',
        angular: 'angular/angular/angular',
        bootstrap: 'angular/angular-bootstrap/ui-bootstrap'
    }
});

// Load the app by importing the 'main' module.
requirejs(['main']);
