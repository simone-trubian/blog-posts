define([], function () {

    config.$inject=['$routeProvider'];

    function config($routeProvider) {
          $routeProvider
            .when('/',
                  {templateUrl: 'app/home/home.html',
                   controller: 'HomeController'})
            .otherwise({redirectTo: '/'});
      }

    return config;
});
