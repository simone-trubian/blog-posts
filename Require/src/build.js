({
    appDir: './',
    baseUrl: 'app',
    dir: '../build',
    fileExclusionRegExp: /^node_modules/,
    optimize: 'closure',
    closure: {
        CompilerOptions: {},
        CompilationLevel: 'SIMPLE_OPTIMIZATIONS',
        loggingLevel: 'TRACE'
    },
    paths: {
        jquery: 'empty:'
    },
    modules: [
        {
            name: 'main'
        }
    ]
})
