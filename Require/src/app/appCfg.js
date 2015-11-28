'use strict';

define([], function () {

    config.$inject=['$routeProvider'];

    return config;

    function config($routeProvider) {
          $routeProvider
            .when('/',
                  {templateUrl: 'app/home/home.html',
                   controller: 'HomeController'})
            .otherwise({redirectTo: '/'});
      }

});
