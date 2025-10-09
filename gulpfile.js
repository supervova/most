/* eslint-disable no-console */

// -----------------------------------------------------------------------------
// #region: 📥 IMPORTS
// -----------------------------------------------------------------------------

import { src, dest, series, parallel, watch } from 'gulp';
import { deleteAsync } from 'del';
import path from 'node:path';
import fs from 'node:fs';
import plumberPkg from 'gulp-plumber';
import sizePkg from 'gulp-size';
import browserSyncModule from 'browser-sync';
import fg from 'fast-glob';
import gulpIfPkg from 'gulp-if';
import twigPkg from 'gulp-twig';
import dataPkg from 'gulp-data';
import sassPkg from 'gulp-dart-sass';
import sourcemapsPkg from 'gulp-sourcemaps';
import postcss from 'gulp-postcss';
import postcssImport from 'postcss-import';
import postcssCustomMedia from 'postcss-custom-media';
import postcssNesting from 'postcss-nesting';
import postcssPresetEnv from 'postcss-preset-env';
import postcssPxToRem from 'postcss-pxtorem';
import autoprefixer from 'autoprefixer';
import cssnano from 'cssnano';
import gulpEsbuildPkg from 'gulp-esbuild';
import svgSprite from 'gulp-svg-sprite';
import imagemin, { gifsicle, mozjpeg, optipng, svgo } from 'gulp-imagemin';

const removeCssComments = () => ({
  postcssPlugin: 'remove-css-comments',
  Comment(comment) {
    comment.remove();
  },
});
removeCssComments.postcss = true;

const plumber = plumberPkg.default ?? plumberPkg;
const gulpSize = sizePkg.default ?? sizePkg;
const gulpIf = gulpIfPkg.default ?? gulpIfPkg;
const twig = twigPkg.default ?? twigPkg;
const data = dataPkg.default ?? dataPkg;
const sass = sassPkg.default ?? sassPkg;
const sourcemaps = sourcemapsPkg.default ?? sourcemapsPkg;
const gulpEsbuild = gulpEsbuildPkg.default ?? gulpEsbuildPkg;
const browserSyncApi = browserSyncModule.create
  ? browserSyncModule
  : browserSyncModule.default;
const bs = browserSyncApi.create();

const handleErrors = (title) =>
  plumber({
    errorHandler(error) {
      console.error(`\n[${title}] ${error.message}`);
      this.emit('end');
    },
  });

let isProd = process.env.NODE_ENV === 'production';

// #endregion

// -----------------------------------------------------------------------------
// #region: 👉 PATHS
// -----------------------------------------------------------------------------

const paths = {
  src: 'src',
  dist: 'dist',
  public: 'public',
  templates: {
    base: 'src/templates',
    pagesBase: 'src/templates/pages',
    pages: 'src/templates/pages/**/*.twig',
    watch: 'src/templates/**/*.{twig,json}',
    data: 'src/templates/data',
  },
  css: {
    entries: [
      'src/css/**/*.{scss,css}',
      '!src/css/**/_*.scss',
      '!src/css/update/*.css',
    ],
    watch: 'src/css/**/*.{scss,css}',
    outDev: 'public/projects/most/css',
    outProd: 'public/projects/most/css',
  },
  js: {
    entries: ['main.js', 'search.js'],
    watch: 'src/js/**/*.js',
    outDev: 'public/projects/most/js',
    outProd: 'public/projects/most/js',
  },
  icons: {
    src: 'src/icons/sprite/**/*.svg',
    outDev: 'public/projects/most/icons',
    outProd: 'public/projects/most/icons',
  },
  images: {
    src: [
      'src/images/**/*.{png,jpg,jpeg,webp,gif,svg}',
      '!src/images/placeholders/**/*.{png,jpg,jpeg,webp,gif,svg}',
    ],
    outDev: 'public/projects/most/images',
    outProd: 'public/projects/most/images',
  },
  placeholders: {
    src: 'src/images/placeholders/**/*.{png,jpg,jpeg,webp,gif,svg}',
    base: 'src/images/placeholders',
    outDev: 'public/projects/most/images/placeholders',
  },
  core: {
    src: 'dev-core/**/*',
    base: 'dev-core',
    outDev: 'dist',
  },
  templateAssets: {
    src: [
      'src/templates/data/search.json',
      'src/templates/*.tpl',
      '!src/templates/*~.tpl',
    ],
    base: 'src/templates',
    dest: 'public/projects/most/templates',
    watch: ['src/templates/*.tpl', 'src/templates/data/search.json'],
  },
};

// #endregion

// -----------------------------------------------------------------------------
// #region: 💽 DATA
// -----------------------------------------------------------------------------

function readJSONSafe(file) {
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch {
    return null;
  }
}

function gatherData(filePath) {
  const slug = path.basename(filePath, path.extname(filePath));

  const dataRoot = paths.templates.data;
  const hasDataDir = fs.existsSync(dataRoot);
  const sharedDataEntries = hasDataDir
    ? fg.sync(['**/*.json', '!pages/**/*.json'], { cwd: dataRoot })
    : [];

  const sharedData = sharedDataEntries.reduce((acc, relativePath) => {
    const absolutePath = path.join(dataRoot, relativePath);
    const parsed = readJSONSafe(absolutePath);
    if (!parsed) {
      return acc;
    }

    const segments = relativePath.replace(/\\/g, '/').split('/');
    const last = segments.pop().replace(/\.json$/, '');
    let node = acc;

    segments.forEach((segment) => {
      if (!node[segment]) {
        node[segment] = {};
      }
      node = node[segment];
    });

    node[last] = parsed;
    return acc;
  }, {});

  const pageDataPath = path.join(dataRoot, 'pages', `${slug}.json`);
  const pageData = readJSONSafe(pageDataPath) || {};

  const defaultSite = {
    name: 'МОСТ.Медиа',
    home_url: '/',
    assets_prefix: '',
    project_prefix: '/projects/most',
    navigation_label: 'Главное меню',
    twitter_creator: '',
    logo: {
      path: '',
      alt: 'МОСТ.Медиа',
      width: 156,
      height: 48,
    },
    navigation: [
      { label: '', url: '#', class: 'site-header-link' },
      { label: '', url: '#', class: 'site-header-link' },
      { label: '', url: '#', class: 'site-header-link' },
      { label: '', url: '#', class: 'site-header-link' },
      { label: '', url: '#', class: 'site-header-link' },
    ],
    cta: {
      label: '',
      url: '#',
    },
    search: {
      label: 'Поиск',
      title: '',
      close_label: '',
      input_label: '',
      placeholder: '',
      submit_label: '',
      examples_title: '',
      examples: ['', '', ''],
      results_page: '/search',
      param: 'q',
    },
    footer: {
      copy: '',
    },
  };

  const defaultPage = {
    slug,
    title: slug.charAt(0).toUpperCase() + slug.slice(1),
    meta_title: null,
    meta_description: '',
    lang: 'ru',
    body_classes: '',
    skip_link_label: 'Перейти к содержимому',
  };

  const site = {
    ...defaultSite,
    ...(sharedData.site || {}),
    ...(pageData.site || {}),
  };

  const page = {
    ...defaultPage,
    ...(pageData.page || {}),
  };

  const contentRaw = pageData.content || {};

  const extras = {
    ...sharedData,
    ...(pageData.data || {}),
  };

  if (extras.site) {
    delete extras.site;
  }
  if (extras.legacy) {
    delete extras.legacy;
  }

  const legacyDefaults = {
    developedby: '',
    meta_title: '',
    meta_description: '',
    meta_robots: '',
    ogtype: '',
    meta_ogimage: '',
    ogimage_small: '',
    thisdomain: '',
    thispageurl: '',
    main_href: '',
    fb_app_id: '',
    base_href: '/',
    canonical: '',
    schemaorg: '',
    projectcss: '',
    addheadtags: '',
    head_extra: '',
    body_extra: '',
    foot_extra: '',
    header: '',
    footer: '',
    loginform: '',
    cookiesalert: '',
    page_content_html: '',
    antiframe: '',
    pushstatejs: '',
    phraseclose: '',
    btn_close: '',
    phraseok: '',
    btn_ok: '',
    phrasecancel: '',
    btn_cancel: '',
    phraseyes: '',
    btn_yes: '',
    phraseno: '',
    btn_no: '',
    country_code: '',
    user_lng: '',
    lng_html: page.lang || 'ru',
    body_class: page.body_classes || '',
    blog_settings: { twittercreator: '' },
    assets_version: '',
  };

  const legacy = {
    ...legacyDefaults,
    ...(sharedData.legacy || {}),
    ...(pageData.legacy || {}),
  };

  if (!legacy.meta_title) {
    legacy.meta_title = page.meta_title;
  }
  if (!legacy.meta_description) {
    legacy.meta_description = page.meta_description;
  }
  if (!legacy.blog_settings) {
    legacy.blog_settings = { twittercreator: '' };
  }
  if (!legacy.blog_settings.twittercreator) {
    legacy.blog_settings.twittercreator = site.twitter_creator || '';
  }
  if (!legacy.lng_html) {
    legacy.lng_html = page.lang || 'ru';
  }
  if (!legacy.body_class) {
    legacy.body_class = page.body_classes || '';
  }
  if (!legacy.developedby) {
    legacy.developedby = '';
  }

  const assetBase = paths.public;
  const versionTargets = [
    path.join(assetBase, 'projects/most/css/enhancements.css'),
    path.join(assetBase, 'projects/most/css/search.css'),
    path.join(assetBase, 'projects/most/js/search.js'),
  ];

  const getMtime = (file) => {
    try {
      return fs.statSync(file).mtimeMs;
    } catch {
      return 0;
    }
  };

  const assetsTimestamp = versionTargets.reduce(
    (acc, target) => Math.max(acc, getMtime(target)),
    0
  );

  const assetsVersion = assetsTimestamp
    ? String(Math.floor(assetsTimestamp))
    : String(Date.now());

  site.assets_version = assetsVersion;
  legacy.assets_version = assetsVersion;

  const resolvePlaceholderImage = (imagePath) => {
    if (!imagePath) {
      return imagePath;
    }

    const placeholderPrefix = '/placeholders/';
    if (imagePath.startsWith(placeholderPrefix)) {
      const relativePath = imagePath.slice(placeholderPrefix.length);
      return `${site.project_prefix}/images/placeholders/${relativePath}`;
    }

    if (isProd) {
      return imagePath;
    }

    const fileName = path.basename(imagePath);
    const placeholderAbsolute = path.join(
      paths.src,
      'images/placeholders',
      fileName
    );

    if (fs.existsSync(placeholderAbsolute)) {
      return `${site.project_prefix}/images/placeholders/${fileName}`;
    }

    return imagePath;
  };

  const content = { ...contentRaw };

  if (contentRaw.top_post) {
    content.top_post = {
      ...contentRaw.top_post,
      image: resolvePlaceholderImage(contentRaw.top_post.image),
    };
  }

  if (Array.isArray(contentRaw.banners)) {
    content.banners = contentRaw.banners.map((banner) => ({
      ...banner,
      image: resolvePlaceholderImage(banner.image),
    }));
  }

  if (Array.isArray(contentRaw.latest_posts)) {
    content.latest_posts = contentRaw.latest_posts.map((post) => ({
      ...post,
      image: resolvePlaceholderImage(post.image),
    }));
  }

  if (contentRaw.latest_posts_link) {
    content.latest_posts_link = { ...contentRaw.latest_posts_link };
  }

  if (!page.meta_title) {
    page.meta_title = `${site.name} — ${page.title}`;
  }

  if (!page.meta_description) {
    page.meta_description = '';
  }

  return {
    ENV: isProd ? 'production' : 'development',
    page,
    site,
    content,
    data: extras,
    ...legacy,
  };
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 💇🏻‍♀️ STYLES
// -----------------------------------------------------------------------------

function isScss(file) {
  return path.extname(file.path) === '.scss';
}

function stylesDev() {
  return src(paths.css.entries, { allowEmpty: true, base: 'src/css' })
    .pipe(handleErrors('styles:dev'))
    .pipe(gulpIf(isScss, sourcemaps.init()))
    .pipe(gulpIf(isScss, sass.sync().on('error', sass.logError)))
    .pipe(
      postcss([
        postcssImport(),
        postcssCustomMedia(),
        postcssNesting(),
        postcssPresetEnv({ stage: 2 }),
        postcssPxToRem({ rootValue: 16, propList: ['*'], mediaQuery: false }),
        removeCssComments(),
        autoprefixer(),
      ])
    )
    .pipe(gulpIf(isScss, sourcemaps.write('.')))
    .pipe(dest(paths.css.outDev))
    .pipe(gulpSize({ title: 'css' }))
    .pipe(bs.stream({ match: '**/*.css' }));
}

function stylesProd() {
  return src(paths.css.entries, { allowEmpty: true, base: 'src/css' })
    .pipe(handleErrors('styles:prod'))
    .pipe(gulpIf(isScss, sass.sync().on('error', sass.logError)))
    .pipe(
      postcss([
        postcssImport(),
        postcssCustomMedia(),
        postcssNesting(),
        postcssPresetEnv({
          stage: 2,
          features: {
            'cascade-layers': false,
            'custom-properties': false,
            'font-variant-property': false,
            'is-pseudo-class': false,
            'logical-properties-and-values': false,
          },
        }),
        postcssPxToRem({
          rootValue: 16,
          propList: [
            'font',
            'font-size',
            'line-height',
            'letter-spacing',
            'word-spacing',
            'margin*',
            'padding*',
            '--font-size*',
            '--letter-spacing*',
            '--padding-top*',
            '--padding-bottom*',
            '--size*',
            '--radius*',
            '!--font-size-doc',
          ],
          selectorBlackList: [],
          exclude: null,
          mediaQuery: false,
          minPixelValue: 0,
        }),
        removeCssComments(),
        autoprefixer(),
        cssnano(),
      ])
    )
    .pipe(gulpSize({ title: 'css (prod)' }))
    .pipe(dest(paths.css.outProd));
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 📜 SCRIPTS
// -----------------------------------------------------------------------------

function bundleScripts({ production }) {
  const entries = paths.js.entries || [];
  const destination = production ? paths.js.outProd : paths.js.outDev;
  const titleBase = production ? 'js (prod)' : 'js';

  const tasks = entries.map((fileName) => {
    const entryPath = path.join(paths.src, 'js', fileName);

    return new Promise((resolve, reject) => {
      const stream = src(entryPath, { allowEmpty: true })
        .pipe(
          handleErrors(
            production ? `scripts:prod:${fileName}` : `scripts:dev:${fileName}`
          )
        )
        .pipe(
          gulpEsbuild({
            bundle: true,
            sourcemap: !production,
            minify: production,
            format: 'esm',
            target: ['es2020'],
            outfile: fileName,
          })
        )
        .pipe(gulpSize({ title: `${titleBase} ${fileName}` }))
        .pipe(dest(destination));

      stream.on('finish', resolve);
      stream.on('error', reject);
    });
  });

  return Promise.all(tasks).then(() => {
    if (!production) {
      bs.reload();
    }
  });
}

function scriptsDev() {
  return bundleScripts({ production: false });
}

function scriptsProd() {
  return bundleScripts({ production: true });
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 🖼️ IMAGES AND ICONS
// -----------------------------------------------------------------------------

function icons() {
  return src(paths.icons.src)
    .pipe(handleErrors('icons'))
    .pipe(
      svgSprite({
        mode: {
          symbol: {
            dest: '.', // Mode specific output directory
            sprite: 'sprite.svg', // Sprite path and name
            prefix: '.', // Prefix for CSS selectors
            dimensions: '', // Suffix for dimension CSS selectors
          },
        },
        svg: {
          xmlDeclaration: false, // strip out the XML attribute
          doctypeDeclaration: false, // don't include the !DOCTYPE declaration
        },
        shape: {
          transform: [{ svgo: { plugins: [{ name: 'preset-default' }] } }],
        },
      })
    )
    .pipe(dest(isProd ? paths.icons.outProd : paths.icons.outDev))
    .pipe(bs.stream());
}

function images() {
  return src(paths.images.src, { encoding: false })
    .pipe(handleErrors('images'))
    .pipe(
      isProd
        ? imagemin([
            gifsicle({ interlaced: true }),
            mozjpeg({ quality: 80, progressive: true }),
            optipng({ optimizationLevel: 5 }),
            svgo({ plugins: [{ name: 'preset-default' }] }),
          ])
        : plumber()
    )
    .pipe(dest(isProd ? paths.images.outProd : paths.images.outDev))
    .pipe(bs.stream());
}

function copyPlaceholders() {
  if (isProd) {
    return Promise.resolve();
  }

  return src(paths.placeholders.src, {
    base: paths.placeholders.base,
    allowEmpty: true,
    encoding: false,
  })
    .pipe(dest(paths.placeholders.outDev))
    .pipe(
      bs.stream({
        match: [
          '**/*.png',
          '**/*.jpg',
          '**/*.jpeg',
          '**/*.gif',
          '**/*.svg',
          '**/*.webp',
        ],
      })
    );
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 🔮 CORE ASSETS
// -----------------------------------------------------------------------------

function copyCoreAssets() {
  if (isProd) {
    return Promise.resolve();
  }

  return src(paths.core.src, { base: paths.core.base, allowEmpty: true })
    .pipe(dest(paths.core.outDev))
    .pipe(bs.stream({ match: ['**/*.css', '**/*.js'] }));
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 📖 PAGES
// -----------------------------------------------------------------------------

const twigFilters = [
  { name: 'trans', func: (s) => s },
  {
    name: 'tzdate',
    func: (value, tz = 'Europe/Podgorica', lang = 'en') => {
      try {
        return new Date(value).toLocaleString(lang, {
          timeZone: tz,
          dateStyle: 'medium',
          timeStyle: 'short',
        });
      } catch {
        return value;
      }
    },
  },
];

const twigFunctions = [
  { name: 'asset', func: (p, prefix = '') => `${prefix || ''}${p}` },
];

function pagesDev() {
  return src(paths.templates.pages, { base: paths.templates.pagesBase })
    .pipe(handleErrors('pages:dev'))
    .pipe(data((file) => gatherData(file.path)))
    .pipe(
      twig({
        base: paths.templates.base,
        filters: twigFilters,
        functions: twigFunctions,
      })
    )
    .pipe(dest(paths.dist))
    .pipe(gulpSize({ title: 'html' }))
    .pipe(bs.stream());
}

function pagesProd() {
  return src(paths.templates.pages, { base: paths.templates.pagesBase })
    .pipe(handleErrors('pages:prod'))
    .pipe(data((file) => gatherData(file.path)))
    .pipe(
      twig({
        base: paths.templates.base,
        filters: twigFilters,
        functions: twigFunctions,
      })
    )
    .pipe(dest(paths.dist))
    .pipe(gulpSize({ title: 'html (prod)' }));
}

function copyHtmlToPublic() {
  return src(path.join(paths.dist, '**/*.html')).pipe(dest(paths.public));
}

function copyTemplateAssets() {
  return src(paths.templateAssets.src, {
    base: paths.templateAssets.base,
    allowEmpty: true,
  })
    .pipe(handleErrors('templates:static'))
    .pipe(dest(paths.templateAssets.dest));
}

// #endregion

// -----------------------------------------------------------------------------
// #region: 💻 SERVER AND CLEANING
// -----------------------------------------------------------------------------

function cleanDist() {
  return deleteAsync([paths.dist]);
}

function cleanPublic() {
  return deleteAsync([paths.public]);
}

function serve(done) {
  bs.init({
    server: { baseDir: [paths.dist, paths.public] },
    open: false,
    notify: false,
    port: 9000,
  });

  watch(paths.templates.watch, pagesDev);
  watch(paths.css.watch, stylesDev);
  watch(paths.js.watch, scriptsDev);
  watch(paths.icons.src, icons);
  watch(paths.images.src, images);
  watch(paths.placeholders.src, copyPlaceholders);
  watch(paths.core.src, copyCoreAssets);
  watch(paths.templateAssets.watch, copyTemplateAssets);

  done();
}

function setProdMode(done) {
  isProd = true;
  process.env.NODE_ENV = 'production';
  done();
}

// #endregion

// -----------------------------------------------------------------------------
// #region: ✅ TASKS
// -----------------------------------------------------------------------------

const dev = series(
  cleanDist,
  parallel(
    stylesDev,
    scriptsDev,
    icons,
    images,
    pagesDev,
    copyCoreAssets,
    copyPlaceholders,
    copyTemplateAssets
  ),
  serve
);

const build = series(
  setProdMode,
  cleanDist,
  cleanPublic,
  parallel(
    stylesProd,
    scriptsProd,
    () => icons(),
    () => images()
  ),
  pagesProd,
  parallel(copyHtmlToPublic, copyTemplateAssets)
);

const clean = parallel(cleanDist, cleanPublic);

export { build, copyPlaceholders as ph, icons, clean, dev };

export default dev;

// #endregion
