# One Tag to rule them all, One Tag to find them, One Tag to bring them all, and in the page bind them

please note that this post uses these versions of the following libraries:
<pre code=json>
    "angular": "^1.4.8",
    "requirejs": "^2.1.20"
</pre>
Despite well structured Angular still misses some features that make the life of a programmer easier, some of which are in fact *language* shortcomings. For instance EcmaScript 5 does not have a real module system that allows for exporting definition from a file and importing them in another. Module systems are nowadays a necessary feature that helps braking down a project and use libraries developed by a third party.
The reason for a lack of module system is historical, as traditionally JavaScript was used uniquely as a front-end language for AJAX applications, so importing can simply be achieved by adding a <script></script> tag to a web page. This is still possible to this day, but there is no such equivalent for a back-end application. Also doing so quickly escalates in importing tens of files in a web page which becomes a nightmare when it's time to refactor or get a single page application ready for production.

The latter is precisely the reason for this post: a how to manage dependencies in clean way so that it becomes easy to maintain both the development and production environment.

Some of the differences between a development and a production environment is that they serve different purposes. During development the programmer wants all the required dependencies on the local machine, in a human readable format, and there are no constraints when it come to size of the codebase (dependencies included). However when serving an app to the browser, it is best to gather all dependencies from CDN's and serve a minfied version of the actual application. This has several advantages such as avoiding to fetch already cached libraries, minimising load times, and serving an optimised version of the application.

As JS does not come with a module system the most common workaround is using a library called Require JS to do that instead. For those used to a module system using Require looks unfamiliar: as there are no language primitives like `import` Require asks the user to wrap all code in modules in a function called `define` and expose using the function ``. Furthermore the library also requires a configuration file, used to manage all external and user-defined dependencies.

### Task 1 set up the project to use require and load it with one script tag only.
The first big advantage of using the Require JS library is that all is needed in the index.html page is one single tag. This makes life easy as the page can be forgotten thus concentrating efforts on programming. Require needs a scrpt tag to bootstrap itself into the project, and also an extra attribute used to load the configuration file. The tag looks like:
<pre><code class="html"><script src="node_modules/requirejs/require.js" data-main="app.js"></script>
</code></pre>
The configuration file, in this case app.js is where all the dependencies, both external and internal are managed. For a trivial project it could look like:
<pre><code class="javascript">requirejs.config({
    baseUrl: 'node_modules',
    paths: {
        main: '../app/main',
        jquery: 'jquery/dist/jquery'
    }
});
</code></pre>
Notice that differently from a language-managed module system here the programmer is forced to specify paths for all modules. This can get tricky, for instance to my knowlede the Require JS version used in this post is only able to move back from a directory one level deep. This means that all external dependencies had to be put in the root of the project directory. The last line is also necessary, as it's the entry point for the entire app. Launching a web server the app can be tested to see that everything is in working order.

### Step 2 switch development and production just by changing one file.
Before adding any new modules or dependencies is best to get the hang of switching from development to production easily. To recap we want to be able to serve all external dependencies from CDN's and have a single point where to do that. The best way to achieve that is to change the import tag in the index.html page and create a production verson of the configuration file bootstrapped by the tag. So the tag becomes
<pre><code class="html"><script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.1.22/require.min.js" data-main="appProd.js"></script>
</code></pre>
and the configuration file.
<pre><code class="javascript">requirejs.config({
    baseUrl: 'node_modules',
    paths: {
        main: '../app/main',
        jquery: '//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min'
    }
});

// Load the app by importing the 'main' module.
requirejs(['main']);
</code></pre>
The sharp-eyed will have noticed that with this configuration even Require is now fetched from a CDN. This gives a very clean dependency management, but it also mean that the project is entirely dependent on this first fetch being satisfied. To test the tag works simply swap it for the previous one, in a real-life project this can be achieved with a templating system managed by the back-end.

### Step 3 compile the entire prod project with the google closure compiler.
Perhaps the most important reason for managing dependencies with Require JS is that it ships with the r.js module that makes compiling an entire app easy. Compiling an entire app requires to give the entire project a well defined structure, so that dependencies can be managed on one hand and the source code can be compiled without interfering with the source code.

### Task 4 Create a seed Angular project, and validate all previous steps.
jjs -cp ../../../../closure/compiler.jar -scripting node_modules/requirejs/bin/r.js -- -o build.js
