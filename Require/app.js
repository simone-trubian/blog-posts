requirejs.config({
    baseUrl: 'node_modules',
    paths: {
        main: '../app/main',
        jquery: 'jquery/dist/jquery'
    }
});

requirejs(['jquery']);
requirejs(['main']);
