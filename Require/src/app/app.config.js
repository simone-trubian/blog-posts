define([], function () {

    config.$inject=['$routeProvider'];

    function config($routeProvider) {
          $routeProvider
            .when('/home',
                  {templateUrl: 'templates/home.html',
                    controller: 'ideasHomeController'})
            .when('/details/:id',
                  {templateUrl:'templates/ideaDetails.html',
                   controller:'ideaDetailsController'})
            .otherwise({redirectTo: '/home'});
      }

    return config;
});
