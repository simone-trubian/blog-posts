// Configure paths so that can be used throughout the project.
requirejs.config({
    baseUrl: 'node_modules',
    paths: {
        main: '../app/main',
        jquery: 'jquery/dist/jquery'
    }
});

// Load the app by importing the 'main' module.
requirejs(['main']);
