/* eslint-disable no-console */
// -----------------------------------------------------------------------------
// #region: 📥 IMPORTS
// -----------------------------------------------------------------------------

import { src, dest, watch, series, parallel } from 'gulp';
import browserSync from 'browser-sync';
import del from 'del';

import plumber from 'gulp-plumber';
import notify from 'gulp-notify';
import newer from 'gulp-newer';
import size from 'gulp-size';

import postcss from 'gulp-postcss';
import sourcemaps from 'gulp-sourcemaps';
import cssnano from 'cssnano';
import postcssImport from 'postcss-import';
import postcssCustomMedia from 'postcss-custom-media';
import postcssNesting from 'postcss-nesting';
import postcssPresetEnv from 'postcss-preset-env';
import postcssPxtorem from 'postcss-pxtorem';
import autoprefixer from 'autoprefixer';
import inlineSvg from 'postcss-inline-svg';

import twig from 'gulp-twig';
import getData from 'gulp-data';

import svgSprite from 'gulp-svg-sprite';

import imagemin, { gifsicle, mozjpeg, optipng, svgo } from 'gulp-imagemin';

import esbuildPlugin from 'gulp-esbuild';
import * as esbuild from 'esbuild';
import path from 'node:path';
import fs from 'node:fs';
import { Transform } from 'node:stream';

const bs = browserSync.create();
const isProd = process.env.NODE_ENV === 'production';

// #endregion

// -----------------------------------------------------------------------------
// #region: 👉 PATHS
// -----------------------------------------------------------------------------

const root = {
  src: './src',
  dist: './dist',
  public: './public',
  assetsDest: './public/assets',
};

const paths = {
  styles: {
    entry: `${root.src}/assets/scss/main.scss`,
    watch: `${root.src}/assets/scss/**/*.{scss,css}`,
    dest: `${root.assetsOut}/css`,
  },
  scripts: {
    entries: {
      app: `${root.src}/assets/js/app.ts`,
      admin: `${root.src}/assets/js/admin.ts`,
    },
    watch: `${root.src}/assets/js/**/*.{ts,tsx,js,jsx}`,
    dest: `${root.assetsOut}/js`,
  },
  pages: {
    base: `${root.src}/templates`,
    pages: `${root.src}/templates/pages/**/*.twig`,
    widgets: `${root.src}/templates/widgets/**/*.twig`,
    assetPage: `${root.src}/templates/asset.twig`,
    dataDir: `${root.src}/templates/data`,
    watch: `${root.src}/templates/**/*.{twig,json}`,
    dest: `${root.public}`,
  },
  sprites: {
    icons: `${root.src}/assets/icons/**/*.svg`,
    flags: `${root.src}/assets/flags/**/*.svg`,
    dest: `${root.assetsOut}/sprites`,
  },
  images: {
    src: `${root.src}/images/**/*.{png,jpg,jpeg,webp,gif,svg}`,
    dest: `${root.assetsOut}/images`,
  },
  static: {
    src: `${root.src}/static/**/*`,
    dest: `${root.public}`,
  },
  devServer: {
    baseDirs: [root.public, root.dist],
  },
};

// #endregion

// -----------------------------------------------------------------------------
// #region: 🧰 UTILS
// -----------------------------------------------------------------------------
function handleErrors(task) {
  return plumber(
    notify.onError({
      title: `❌ ${task}`,
      message: '<%= error.message %>',
      sound: false,
    })
  );
}

function readDataJSON(dir) {
  const out = {};
  if (!fs.existsSync(dir)) return out;

  const walk = (d) => {
    fs.readdirSync(d).forEach((name) => {
      const p = path.join(d, name);
      const stat = fs.statSync(p);

      if (stat.isDirectory()) {
        walk(p);
        return;
      }

      if (name.endsWith('.json')) {
        try {
          const json = JSON.parse(fs.readFileSync(p, 'utf8'));
          Object.assign(out, json);
        } catch {
          // ignore
        }
      }
    });
  };

  walk(dir);
  return out;
}

function gatherTwigData(file) {
  const site = readDataJSON(path.join(paths.pages.dataDir, 'site'));
  const content = readDataJSON(path.join(paths.pages.dataDir, 'content'));
  const page = { path: file.path, basename: path.basename(file.path, '.twig') };
  const env = { isProd, timestamp: Date.now() };

  return { site, content, page, env };
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 🎨 STYLES
// -----------------------------------------------------------------------------

const touch = () =>
  new Transform({
    objectMode: true,
    transform(file, enc, cb) {
      if (file.stat) {
        // eslint-disable-next-line no-param-reassign
        file.stat.mtime = new Date();
      }
      cb(null, file);
    },
  });

function styles() {
  const plugins = [
    postcssImport(),
    inlineSvg(),
    postcssCustomMedia(),
    postcssNesting(),
    postcssPresetEnv({ stage: 1 }),
    postcssPxtorem({ propList: ['*'], replace: true }),
    autoprefixer(),
  ];

  if (isProd) {
    plugins.push(cssnano({ preset: 'default' }));
  }

  return src(paths.styles.entry, { sourcemaps: !isProd })
    .pipe(handleErrors('styles'))
    .pipe(sourcemaps.init())
    .pipe(postcss(plugins))
    .pipe(sourcemaps.write('.'))
    .pipe(touch())
    .pipe(dest(paths.styles.dest))
    .pipe(size({ title: 'css' }))
    .pipe(bs.stream());
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 📜 SCRIPTS
// -----------------------------------------------------------------------------

function scripts() {
  const commonOptions = {
    bundle: true,
    target: 'es2020',
    outdir: paths.scripts.dest,
    entryNames: '[name]',
    esbuild,
  };

  const options = isProd
    ? {
        ...commonOptions,
        format: 'iife',
        sourcemap: false,
        minify: true,
        define: { 'process.env.NODE_ENV': '"production"' },
        logLevel: 'warning',
      }
    : {
        ...commonOptions,
        format: 'esm',
        sourcemap: true,
        define: { 'process.env.NODE_ENV': '"development"' },
        incremental: true,
        logLevel: 'info',
      };

  return src(Object.values(paths.scripts.entries))
    .pipe(handleErrors('scripts'))
    .pipe(esbuildPlugin(options))
    .pipe(dest(paths.scripts.dest))
    .pipe(size({ title: 'js' }))
    .pipe(bs.stream());
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 📄 PAGES
// -----------------------------------------------------------------------------

function pages() {
  return src(paths.pages.pages)
    .pipe(handleErrors('pages'))
    .pipe(getData((file) => gatherTwigData(file)))
    .pipe(twig({ errorLogToConsole: true }))
    .pipe(dest(paths.pages.dest))
    .pipe(bs.stream());
}

// #endregion

// -----------------------------------------------------------------------------
// #region: ⭐️ SVG SPRITES
// -----------------------------------------------------------------------------

function spriteIcons() {
  return src(paths.sprites.icons)
    .pipe(handleErrors('sprite:icons'))
    .pipe(
      svgSprite({
        shape: { transform: [] },
        mode: { symbol: { sprite: 'sprite.svg', example: false } },
        svg: { xmlDeclaration: false, doctypeDeclaration: false },
      })
    )
    .pipe(dest(paths.sprites.dest))
    .pipe(bs.stream());
}

function spriteFlags() {
  return src(paths.sprites.flags)
    .pipe(handleErrors('sprite:flags'))
    .pipe(
      svgSprite({
        shape: { transform: [] },
        mode: { symbol: { sprite: 'flags.svg', example: false } },
        svg: { xmlDeclaration: false, doctypeDeclaration: false },
      })
    )
    .pipe(dest(paths.sprites.dest))
    .pipe(bs.stream());
}

const sprites = parallel(spriteIcons, spriteFlags);

// #endregion

// -----------------------------------------------------------------------------
// #region: 🖼️ IMAGES
// -----------------------------------------------------------------------------

function images() {
  return src(paths.images.src, { encoding: false })
    .pipe(handleErrors('images'))
    .pipe(newer(paths.images.dest))
    .pipe(
      imagemin([
        gifsicle({ interlaced: true }),
        mozjpeg({ quality: isProd ? 82 : 86, progressive: true }),
        optipng({ optimizationLevel: isProd ? 5 : 1 }),
        svgo({
          plugins: [
            { name: 'preset-default' },
            { name: 'removeViewBox', active: false },
            { name: 'cleanupIDs', params: { remove: false } },
          ],
        }),
      ])
    )
    .pipe(dest(paths.images.dest))
    .pipe(size({ title: 'images' }))
    .pipe(bs.stream());
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 📦 COPY / CLEAN
// -----------------------------------------------------------------------------
function clean() {
  return del([root.public, root.dist]);
}

function copyStatic() {
  return src(paths.static.src, { dot: true })
    .pipe(handleErrors('copy:static'))
    .pipe(dest(paths.static.dest));
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 🌐 SERVER + WATCH
// -----------------------------------------------------------------------------

function serve() {
  bs.init({
    server: {
      baseDir: paths.devServer.baseDirs,
      routes: {
        '/assets': `${root.public}/assets`,
      },
    },
    open: false,
    notify: false,
    ghostMode: false,
    ui: false,
  });

  watch(paths.styles.watch, styles);
  watch(paths.scripts.watch, scripts);
  watch(paths.pages.watch, pages);
  watch(paths.sprites.icons, sprites);
  watch(paths.sprites.flags, sprites);
  watch(paths.images.src, images);
  watch(paths.static.src, series(copyStatic, bs.reload));
}

// #endregion

// -----------------------------------------------------------------------------
// #region: ✅ TASKS
// -----------------------------------------------------------------------------
export const cleanAll = clean;

export const buildStyles = styles;
export const buildScripts = scripts;
export const buildPages = pages;
export const buildSprites = sprites;
export const buildImages = images;
export const copy = copyStatic;

export const dev = series(
  clean,
  parallel(copyStatic, sprites, images),
  parallel(styles, scripts, pages),
  serve
);

export const build = series(
  clean,
  parallel(copyStatic, sprites, images),
  parallel(styles, scripts, pages)
);

export default dev;

// #endregion
