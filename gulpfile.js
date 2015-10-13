// Core libraries
var gulp       = require('gulp'),
    gutil      = require('gulp-util'),
    livereload = require('gulp-livereload'),
    path       = require('path'),
    express    = require('express'),
    app        = express(),
    rename     = require('gulp-rename'),
    del        = require('del');

// Development Environment libraries
var jade       = require('gulp-jade'),
    browserify = require('gulp-browserify'),
    sass       = require('gulp-sass'),
    inlineimage = require('gulp-inline-image');

// Production push
var s3          = require("gulp-s3"),
    rev         = require('gulp-rev'),
    revReplace  = require('gulp-rev-replace'),
    runSequence = require('run-sequence'),
    uglify      = require('gulp-uglify');
    ifElse      = require('gulp-if');

isProd = function() {
  return process.env.GULP_ENV === 'production';
}

gulp.task('asset-pipeline', [ 'coffee', 'styles' ], function() {

  var manifest = gulp.src("./tmp/rev-manifest.json");

  return gulp.src('src/pages/*.jade')
    .pipe(jade())
    .pipe(ifElse(isProd, revReplace({manifest: manifest})))
    .pipe(gulp.dest('./public'))
    .pipe(livereload());
});

gulp.task('coffee', function() {
  return gulp.src('src/assets/scripts/main.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee'],
    }).on('error', gutil.log))
    .pipe(rename('main.js'))
    .pipe(ifElse(isProd, uglify()))
    .pipe(ifElse(isProd, rev()))
    .pipe(gulp.dest('./public'))
    .pipe(rev.manifest("./tmp/rev-manifest.json", {'base': '.', 'merge': true}))
    .pipe(gulp.dest('.'))
    .pipe(livereload());
});

gulp.task('styles', function() {

  var sass_opts = {includePaths: ['src/assets/stylesheets'] };
  if(isProd()) {
    sass_opts['outputStyle'] = 'compressed';
  }

  gulp.src([ 'src/assets/stylesheets/main.scss', 'third-party/stylesheets/*' ])
    .pipe(sass(sass_opts))
    .on('error', sass.logError)
    .pipe(inlineimage({baseDir: 'src/assets/images'}))
    .pipe(ifElse(isProd, rev()))
    .pipe(gulp.dest('./public'))
    .pipe(rev.manifest("./tmp/rev-manifest.json", {'base': '.', 'merge': true}))
    .pipe(gulp.dest('.'))
    .pipe(livereload());
});

gulp.task('copy-favicon', function() {
  gulp.src('src/assets/images/*.ico')
    .pipe(gulp.dest('./public'))
    .pipe(livereload());
});

gulp.task('copy-fonts', function() {
  gulp.src('src/assets/fonts/*')
    .pipe(gulp.dest('./public'));
});

gulp.task('copy-robots', function() {
  gulp.src('robots/*')
    .pipe(gulp.dest('./public'))
    .pipe(livereload());
});

gulp.task('express', function() {
  app.use(express.static(path.resolve('./public')));
  app.listen(1337);
  gutil.log('Listening on port: 1337');
});

gulp.task('watch', function () {
  livereload.listen();
  gulp.watch('src/pages/**/*.jade',['templates']);
  gulp.watch('src/assets/scripts/*.coffee',['coffee']);
  gulp.watch([ 'src/assets/stylesheets/**/*.scss', 'src/assets/images/*.svg' ],['styles']);
});

gulp.task('clean-public', function() {
  del.sync([ './public/**', '!./public' ] );
});

gulp.task('s3-push', function() {
  aws = JSON.parse(require('fs').readFileSync('./config/aws.json'));
  aws['key']    = eval(aws['key']);
  aws['secret'] = eval(aws['secret']);

  options = { headers: { 'Cache-Control' : 'max-age=31536000, no-transform, public' } };
  gulp.src('./public/**')
    .pipe(s3(aws, options));
});

gulp.task('production', function() {
  process.env.GULP_ENV = 'production';
  runSequence('clean-public', 'create-public', 's3-push', function() { process.env.GULP_ENV = 'development'; } );
});

gulp.task('create-public', [ 'asset-pipeline', 'copy-fonts', 'copy-robots', 'copy-favicon' ]);
gulp.task('default', [ 'express', 'watch', 'create-public' ]);

// TODO
//  - Development push (using good.davesdesrochers.com)
//  - Mocha (testing)
