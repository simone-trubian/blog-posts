define(['app/app.config',
        'home/home.controller',
  ],

  function(config,
           HomeController) {

    var app = angular.module('requireApp', ['ngRoute','ngResource','ngGrid']);

    app.config(config);
    app.controller('HomeController', HomeController);
});
