// Core libraries
var gulp       = require('gulp'),
    gutil      = require('gulp-util'),
    livereload = require('gulp-livereload'),
    path       = require('path'),
    express    = require('express'),
    app        = express(),
    rename     = require('gulp-rename');

// Development Environment libraries
var jade       = require('gulp-jade'),
    browserify = require('gulp-browserify'),
    sass       = require('gulp-sass');

gulp.task('templates', function() {
  return gulp.src('src/pages/*.jade')
    .pipe(jade({ pretty: true }))
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
    .pipe(gulp.dest('./public'))
    .pipe(livereload());
});

gulp.task('styles', function() {
  gulp.src('src/assets/stylesheets/main.scss')
    .pipe(sass({includePaths: ['src/assets/stylesheets']}))
    .on('error', sass.logError)
    .pipe(gulp.dest('./public'))
    .pipe(livereload());
});

gulp.task('copy-images', function() {
  gulp.src('src/assets/images/*')
    .pipe(gulp.dest('./public'))
    .pipe(livereload());
});

gulp.task('copy-fonts', function() {
  gulp.src('src/assets/fonts/*')
    .pipe(gulp.dest('./public'));
});

gulp.task('copy-3rdparty', function() {
  gulp.src('third-party/**/*')
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
  gulp.watch('src/assets/stylesheets/**/*.scss',['styles']);
  gulp.watch('src/assets/images/*.svg', ['copy-images']);
});


gulp.task('default', [ 'express', 'watch', 'templates', 'coffee', 'styles', 'copy-images', 'copy-fonts', 'copy-3rdparty' ]);

// TODO
//  - Development push (using good.davesdesrochers.com)
//  - Production packaging
//  - Minify
//  - Mocha (testing)
//  - Image copies
