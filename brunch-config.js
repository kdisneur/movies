exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/app.js":    /^web\/static\/js/,
        "js/vendor.js": /^web\/static\/vendor|^bower_components/
      }
    },
    stylesheets: {
      joinTo: "css/app.css"
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  // Phoenix paths configuration
  paths: {
    // Which directories to watch
    watched: ["web/static", "test/static"],

    // Where to compile files to
    public: "priv/static"
  },

  conventions: {
    assets: /^(app(\/|\\)assets)/
  },

  // Configure your plugins
  plugins: {
    ES6to5: {
      // Do not use ES6 compiler in vendor code
      ignore: [/^(web\/static\/vendor|bower_components)/]
    },
    browserSync: {
      files: ["web/templates/**/*", "web/static/**/*", "bower_components"]
    },
    sass: {
      options: {
        includePaths: [
          "bower_components/Bootflat/bootflat/scss",
          "bower_components/bootstrap-sass/assets/stylesheets"
        ]
      }
    }
  }
};
