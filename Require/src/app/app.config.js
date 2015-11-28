define([], function () {

    config.$inject=['$routeProvider'];

    function config($routeProvider) {
          $routeProvider
            .when('/home',
                  {templateUrl: 'home/home.html',
                   controller: 'HomeController'})
            .otherwise({redirectTo: '/home'});
      }

    return config;
});
