# One Tag to rule them all, One Tag to find them, One Tag to bring them all, and in the page bind them

### Task 1 set up the project to use require and load it with one script tag only.
### Task 2 make sure development and production can be switched just by changing one file.
### Task 3 compile the entire prod project with the google closure compiler.
jjs -cp ../../../../closure/compiler.jar -scripting node_modules/requirejs/bin/r.js -- -o build.js
### Task 4 Create a seed Angular project, and validate all previous steps.
### Task 5 Add unit tests and validate all previous steps.
### Task 5 Add e2e tests and validate all previous steps.
