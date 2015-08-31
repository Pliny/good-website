// Core libraries
var gulp       = require('gulp'),
    gutil      = require('gulp-util'),
    livereload = require('gulp-livereload'),
    path       = require('path'),
    express    = require('express'),
    app        = express();

// Development Environment libraries
var jade       = require('gulp-jade');

gulp.task('templates', function() {
  return gulp.src('src/pages/*.jade')
    .pipe(jade({ pretty: true }))
    .pipe(gulp.dest('public/'))
    .pipe( livereload());
});

gulp.task('express', function() {
  app.use(express.static(path.resolve('./public')));
  app.listen(1337);
  gutil.log('Listening on port: 1337');
});

gulp.task('watch', function () {
  livereload.listen();
  gulp.watch('src/pages/*.jade',['templates']);
});


gulp.task('default', [ 'express', 'watch', 'templates' ]);
