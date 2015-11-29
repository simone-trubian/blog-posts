'use strict';

define(['home/homeSrv'], function (HomeSrv) {

    HomeCtrl.$inject = ['HomeSrv'];
    return HomeCtrl;

    function HomeCtrl(HomeSrv) {
        var vm = this;

        vm.listName = undefined;
        vm.toDoList = undefined;

        activate();

        function activate() {
            vm.listName = 'Todo List';
            vm.toDoList = HomeSrv.getTDList();
        }
    }
});
