// This module is defined as a require function, also notice that Require JS is
// passed as a paramter to the the namespace formed by the function closure.
define(function (require) {
    // Import modules and bind each to a name. Do not wrap module names in
    // square brackets!!
    var $ = require('jquery');

    // Use jQuery.
    $.fn.load = function () {return 'And I uploaded jQuery too!'}

    // Compose the sentence to put in the webpage.
    var paragraph = document.createElement('p');
    var node = document.createTextNode(
        'I just loaded the main module!' + ' ' + $.fn.load());
    paragraph.appendChild(node);

    var body = document.getElementsByTagName('body')[0];
    body.appendChild(paragraph);
});
