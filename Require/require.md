# One Tag to rule them all, One Tag to find them, One Tag to bring them all, and in the page bind them

Despite well structured Angular still misses some features that make the life of a programmer easier, some of which are in fact *language* shortcomings. For instance EcmaScript 5 does not have a real module system that allows for exporting definition from a file and importing them in another. Module systems are nowadays a necessary feature that helps braking down a project and use libraries developed by a third party.
The reason for a lack of module system is historical, as traditionally JavaScript was used uniquely as a front-end language for AJAX applications, so importing can simply be achieved by adding a <script></script> tag to a web page. This is still possible to this day, but there is no such equivalent for a back-end application. Also doing so quickly escalates in importing tens of files in a web page which becomes a nightmare when it's time to refactor or get a single page application ready for production.

The latter is precisely the reason for this post: a how to manage dependencies in clean way so that it becomes easy to maintain both the development and production environment.

Some of the differences between a development and a production environment is that they serve different purposes. During development the programmer wants all the required dependencies on the local machine, in a human readable format, and there are no constraints when it come to size of the codebase (dependencies included). However when serving an app to the browser, it is best to gather all dependencies from CDN's and serve a minfied version of the actual application. This has several advantages such as avoiding to fetch already cached libraries, minimising load times, and serving an optimised version of the application.

As JS does not come with a module system the most common workaround is using a library called Require JS to do that instead. For those used to a module system using Require looks unfamiliar: as there are no language primitives like `import` Require asks the user to wrap all code in modules in a function called `define` and expose using the function ``. Furthermore the library also requires a configuration file, used to manage all external and user-defined dependencies.

### Task 1 set up the project to use require and load it with one script tag only.
### Task 2 make sure development and production can be switched just by changing one file.
### Task 3 compile the entire prod project with the google closure compiler.
jjs -cp ../../../../closure/compiler.jar -scripting node_modules/requirejs/bin/r.js -- -o build.js
### Task 4 Create a seed Angular project, and validate all previous steps.
### Task 5 Add unit tests and validate all previous steps.
### Task 5 Add e2e tests and validate all previous steps.
