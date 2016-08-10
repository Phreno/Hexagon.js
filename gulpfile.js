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
  BUILD     : "build",
  CLEAN     : "clean",
  CONCAT    : "concat",
  RENDER_JS : "render:js",
  TEST      : "test"
};

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
gulp.task( action.CLEAN, function () {
  del( bundle.config.folder.dist );
  del( bundle.config.folder.src + bundle.config.file.coffeeAll );
});

/**
 * Concatene les sources coffeescript.
 * */
gulp.task( action.CONCAT, function () {
  gulp
  .src( bundle.config.filter.src )
  .pipe( concat( bundle.config.file.coffeeAll ))
  .pipe( gulp.dest( bundle.config.folder.src ));
});

/**
 * Generation des sources du livrable pour un navigateur.
 * */
gulp.task( action.RENDER_JS, function () {
  gulp
  .src( bundle.config.folder.src + bundle.config.file.coffeeAll )
  .pipe( coffeeify() )
  .pipe( gulp.dest( bundle.config.folder.dist ));
});

/**
 * Effectue toutes les operations de build.
 * */
gulp.task( action.BUILD, [ action.CLEAN, action.CONCAT, action.RENDER_JS ]);
