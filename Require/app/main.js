define(function (require) {
    // Load any app-specific modules
    // with a relative require call,
    // like:
    //var messages = require('./messages');

    // Load library/vendor modules using
    // full IDs, like:
    //var print = require('print');

    var paragraph = document.createElement('p');
    var node = document.createTextNode('I just loaded stuff!');
    paragraph.appendChild(node);

    var body = document.getElementsByTagName('body')[0];
    body.appendChild(paragraph);
});
