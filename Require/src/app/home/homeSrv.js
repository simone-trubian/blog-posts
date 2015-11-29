'use strict';

define([], function () {

    return HomeSrv

    function HomeSrv () {
        var service = {
            getTDList: getTDList
        }

        return service;

        function getTDList () {
          return [
              {date:'today', action:'buy milk'},
              {date:'today', action:'pub quiz'},
              {date:'tomorrow', action:'save world'}
          ];
        }
    }
});
