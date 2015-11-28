define([], function () {

    HomeController.$inject=[
      '$scope'
    ];

    function HomeController(
        $scope
        ) {

        $scope.lisName = 'Todo List';
        $scope.gridOptions = {
            data: 'ideas',
            columnDefs: [
                {field: 'name', displayName: 'Name'},
                {field: 'technologies', displayName: 'Technologies'},
                {field: 'platform', displayName: 'Platforms'},
                {field: 'status', displayName: 'Status'},
                {field: 'devsNeeded', displayName: 'Vacancies'},
                {field: 'id', displayName: 'View Details'}
            ]
        };
    }
    return HomeController;
});
