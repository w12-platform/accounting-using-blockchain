var gulp = require('gulp');
var rimraf = require('gulp-rimraf');
var htmlreplace = require('gulp-html-replace');
var concat = require('gulp-concat');
var cssnano = require('gulp-cssnano');
const babel = require('gulp-babel');
let uglify = require('gulp-uglify-es').default;
var fs = require('fs');

var DEPLOY_DIR = './deploy';
var TMP_DIR = './tmp';

// File where the favicon markups are stored
var FAVICON_DATA_FILE = 'faviconData.json';


gulp.task('clean', function(cb) {
	src_arr = [];

	src_arr.push(DEPLOY_DIR);
	src_arr.push(TMP_DIR);

	return gulp.src(src_arr, {read: false, allowEmpty: true}).pipe(rimraf());
});

gulp.task('copy', function() {
	return gulp.src('./src/img/*.png').pipe(gulp.dest(DEPLOY_DIR + '/img/'));
});

gulp.task('replace', function() {
	return gulp.src('./src/index.html')
	.pipe(htmlreplace({'css': 'index.css', 'js': 'index.js'}))
	.pipe(gulp.dest(DEPLOY_DIR));
});

gulp.task('generate_favicon', function(done) {
	realFavicon.generateFavicon({
		masterPicture: './src/icon.png',
		dest: DEPLOY_DIR + '/favicons',
		iconsPath: './favicons',
		design: {
			ios: {
				pictureAspect: 'noChange',
				assets: {
					ios6AndPriorIcons: false,
					ios7AndLaterIcons: false,
					precomposedIcons: false,
					declareOnlyDefaultIcon: true
				}
			},
			desktopBrowser: {},
			windows: {
				pictureAspect: 'noChange',
				backgroundColor: '#da532c',
				onConflict: 'override',
				assets: {
					windows80Ie10Tile: false,
					windows10Ie11EdgeTiles: {
						small: false,
						medium: true,
						big: false,
						rectangle: false
					}
				}
			},
			androidChrome: {
				pictureAspect: 'noChange',
				themeColor: '#ffffff',
				manifest: {
					display: 'standalone',
					orientation: 'notSet',
					onConflict: 'override',
					declared: true
				},
				assets: {
					legacyIcon: false,
					lowResolutionIcons: false
				}
			}
		},
		settings: {
			scalingAlgorithm: 'Mitchell',
			errorOnImageTooSmall: false
		},
		markupFile: FAVICON_DATA_FILE
	}, function() {
		done();
	});
});

gulp.task('inject_favicon_markups', function() {
	return gulp.src([DEPLOY_DIR + '/index.html'])
			.pipe(realFavicon.injectFaviconMarkups(JSON.parse(fs.readFileSync(FAVICON_DATA_FILE)).favicon.html_code))
			.pipe(gulp.dest(DEPLOY_DIR));
});

gulp.task('concat_css', function() {
	src_arr = []

	src_arr.push('./node_modules/buefy/dist/buefy.css');
	src_arr.push('./lib/bulmaswatch.min.css');
	src_arr.push('./src/css/styles.css');

	return gulp.src(src_arr)
			.pipe(concat('index.css'))
			.pipe(gulp.dest(DEPLOY_DIR));
});

gulp.task('minify_css', function() {
	return gulp.src(DEPLOY_DIR + '/index.css')
			.pipe(cssnano())
			.pipe(gulp.dest(DEPLOY_DIR));
});

gulp.task('babel', function() {
	src_arr = []

	src_arr.push('./src/js/lib.js');
	src_arr.push('./src/js/layout.js');
	src_arr.push('./src/js/game_page.js');
	src_arr.push('./src/js/info_page.js');

	return gulp.src(src_arr)
			// .pipe(babel({presets: ['env']}))
			.pipe(gulp.dest(TMP_DIR))
});

gulp.task('concat_js', function() {
	src_arr = []

	src_arr.push('./node_modules/vue/dist/vue.min.js');
	src_arr.push('./node_modules/vue-router/dist/vue-router.js');
	src_arr.push('./node_modules/buefy/dist/buefy.js');
	src_arr.push('./node_modules/lodash/lodash.min.js');
	src_arr.push('./node_modules/ethjs/dist/ethjs.js');
	src_arr.push('./node_modules/ethjs-contract/dist/ethjs-contract.js');
	src_arr.push('./node_modules/humanize-duration/humanize-duration.js');

	src_arr.push('./lib/all.js');
	src_arr.push('./lib/three.js');

	src_arr.push(TMP_DIR + '/lib.js');
	src_arr.push(TMP_DIR + '/CHOAM.js');
	src_arr.push(TMP_DIR + '/layout.js');
	src_arr.push(TMP_DIR + '/game_page.js');
	src_arr.push(TMP_DIR + '/info_page.js');

	return gulp.src(src_arr)
			.pipe(concat('index.js'))
			.pipe(gulp.dest(DEPLOY_DIR));
});

gulp.task('compress', function() {
	return gulp.src([DEPLOY_DIR + '/index.js'])
			.pipe(uglify())
			.pipe(gulp.dest(DEPLOY_DIR));
});

gulp.task('clean_tmp', function(cb) {
	src_arr = [];

	src_arr.push(TMP_DIR);

	return gulp.src(src_arr, {read: false}).pipe(rimraf());
});

//сборка релиза
gulp.task('_build_production_web',
	gulp.series(
			'clean',
			'copy',
			'replace',
			'generate_favicon',
			'inject_favicon_markups',
			'concat_css',
			'minify_css',
			'babel',
			'concat_js',
			'compress',
			'clean_tmp',
			function(cb){cb()})
);

gulp.task('_check-for-favicon-update', function(cb) {
	var currentVersion = JSON.parse(fs.readFileSync(FAVICON_DATA_FILE)).version;
	realFavicon.checkForUpdates(currentVersion, function(err) {
		if(err)
		{
			throw err;
		}
		cb();
	});
});
