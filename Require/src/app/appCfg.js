'use strict';

define([], function () {

    config.$inject=[
        '$urlRouterProvider',
        '$stateProvider',
        '$resourceProvider'
    ];

    function config(
        $urlRouterProvider,
        $stateProvider,
        $resourceProvider
        ) {
          $stateProvider
              .state('home', {
                  url: '/',
                  templateUrl: 'app/home/home.html',
                  controller: 'HomeCtrl',
                  controllerAs: 'vm',
                  requireLogin: false
          });

          $urlRouterProvider
              .otherwise('/');

          $resourceProvider.defaults.stripTrailingSlashes = false;
      }

    return config;
});
