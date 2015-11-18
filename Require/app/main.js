define(function (require) {
    var paragraph = document.createElement('p');
    var node = document.createTextNode('I just loaded stuff!');
    paragraph.appendChild(node);

    var body = document.getElementsByTagName('body')[0];
    body.appendChild(paragraph);
});
