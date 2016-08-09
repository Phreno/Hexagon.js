var 
gulp = require( "gulp" )
, fs            = require( "fs" )
, coffeeScript  = require( "coffee-script/register" )
, coffeelint    = require( "gulp-coffeelint" )
, coffee        = require( "gulp-coffee" )
, coffeeify     = require( "gulp-coffeeify" )
, del           = require( "del" )
, concat        = require( "gulp-concat" )
, header        = require( "gulp-header" )
, jasmine = require( "gulp-jasmine" )
, bundle = require( "./package.json" ); 

/**
 * Information sur le package.
 * */
var about = {
  template: fs.readFileSync( bundle.config.file.about, "utf-8" ),
  data: {
    name: bundle.name,
    version: bundle.version,
    author: bundle.author.name,
    git: bundle.author.git,
    twitter: bundle.author.twitter,
    license: fs.readFileSync( bundle.config.file.license, "utf-8" ) ,
    repository: bundle.repository.url,
    more: "Forked from https://github.com/rrreese/Hexagon.js"
  }
};

/**
 * Liste des taches programmees.
 * */
var action = {
  BUILD_BROWSER       : "build:browser",
  BUILD_DOCUMENTATION : "build:documentation",

  CLEAN_DIST_BROWSER  : "clean:dist-browser",
  CLEAN_SRC_BROWSER   : "clean:src-browser",
  
  CONCAT_SRC_BROWSER  : "concat:src-browser",

  RENDER_DIST_BROWSER  : "render:dist-browser",

  TEST: "test",
  WATCH: "watch"
};


/**
 * Generation de la documentation.
 * */
gulp.task( action.BUILD_DOCUMENTATION, function () {
  // TODO
  console.log("todo");
});


/**
 * Verification des specifications.
 * */
gulp.task( action.TEST, function () {
  gulp
  .src( bundle.config.filter.spec  )
  .pipe( jasmine( { verbose: true } ))
});

/**
 * Nettoyage du dossier de distribution.
 * */
gulp.task( action.CLEAN_DIST_BROWSER, function () {
  return del( bundle.config.folder.distBrowser );
});


/**
 * Nettoyage des sources coffee concatenees.
 * */
gulp.task( action.CLEAN_SRC_BROWSER, function () {
  return del( bundle.config.file.browserConcat );
});

/**
 * Concatene les sources coffeescript.
 * */
gulp.task( action.CONCAT_SRC_BROWSER, function () {
  gulp
  .src( bundle.config.filter.src )
  .pipe( concat( bundle.config.file.browserConcat ));
});

/**
 * Generation des sources du livrable pour un navigateur.
 * */
gulp.task( action.RENDER_DIST_BROWSER, function () {
  gulp
  .src( bundle.config.file.browserConcat )
  .pipe( coffeeify() )
  .pipe( gulp.dest( bundle.config.folder.distBrowser ));
});


/**
 * Operation de nettoyage et de construction des sources.
 * */
gulp.task( action.BUILD_BROWSER, [ 
  action.CLEAN_DIST_BROWSER, 
  action.CLEAN_SRC_BROWSER, 
  action.CONCAT_SRC_BROWSER, 
  action.RENDER_DIST_BROWSER ]);


/**
 * Mise a jour du livrable.
 * */
gulp.task( action.WATCH, function () {
        gulp.watch( 
          [ bundle.config.filter.src, bundle.config.filter.spec ],  
          [ action.TEST, action.BUILD ]
        );
});
