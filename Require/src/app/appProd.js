// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: '../../node_modules',
    paths: {
        main: '../app/main',
        jquery: '//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min'
    }
});

// Load the app by importing the 'main' module.
requirejs(['main']);
