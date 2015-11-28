'use strict';

define([], function () {

    config.$inject=['$urlRouterProvider', '$stateProvider'];

    function config($urlRouterProvider, $stateProvider) {
          $stateProvider
              .state('home', {
                  url: '/',
                  templateUrl: 'app/home/home.html',
                  controller: 'HomeController',
                  controllerAs: 'vm',
                  requireLogin: false
          });

          $urlRouterProvider
              .otherwise('/');
      }

    return config;
});
