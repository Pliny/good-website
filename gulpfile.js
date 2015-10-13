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
    sass       = require('gulp-sass'),
    inlineimage = require('gulp-inline-image');

// Production push
var s3  = require("gulp-s3"),
    rev = require('gulp-rev'),
    revReplace = require('gulp-rev-replace');

gulp.task('asset-pipeline', [ 'coffee', 'styles' ], function() {

  var manifest = gulp.src("./tmp/rev-manifest.json");

  return gulp.src('src/pages/*.jade')
    .pipe(jade())
    .pipe(revReplace({manifest: manifest}))
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
    .pipe(rev())
    .pipe(gulp.dest('./public'))
    .pipe(rev.manifest("./tmp/rev-manifest.json", {'base': '.', 'merge': true}))
    .pipe(gulp.dest('.'))
    .pipe(livereload());
});

gulp.task('styles', function() {
  gulp.src([ 'src/assets/stylesheets/main.scss', 'third-party/stylesheets/*' ])
    .pipe(sass({includePaths: ['src/assets/stylesheets']}))
    .on('error', sass.logError)
    .pipe(inlineimage({baseDir: 'src/assets/images'}))
    .pipe(rev())
    .pipe(gulp.dest('./public'))
    .pipe(rev.manifest("./tmp/rev-manifest.json", {'base': '.', 'merge': true}))
    .pipe(gulp.dest('.'))
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
  require('del').sync([ './public/**', '!./public' ] );
});

gulp.task('production', [ 'create-public-devel' ], function() {
  aws = JSON.parse(require('fs').readFileSync('./config/aws.json'));
  aws['key']    = eval(aws['key']);
  aws['secret'] = eval(aws['secret']);

  options = { headers: { 'Cache-Control' : 'max-age=31536000, no-transform, public' } };
  gulp.src('./public/**')
    .pipe(s3(aws, options));
});

gulp.task('create-public-devel', [ 'asset-pipeline', 'copy-fonts', 'copy-robots' ]);
gulp.task('default', [ 'express', 'watch', 'create-public-devel' ]);

// TODO
//  - Development push (using good.davesdesrochers.com)
//  - Production packaging
//  - Minify
//  - Mocha (testing)
//  - Image copies
