var config = require('../config.js');
module.exports = function (grunt) {
  grunt.config.set('sails-linker', {
    devJsJade: {
      options: {
        startTag: '<!-- SCRIPTS-->',
        endTag: '<!-- SCRIPTS END-->',
        fileTmpl: "<script type='text/javascript' src='" + config.serverPath + "%s'></script>",
        appRoot: config.localPublic + '/'
      },
      files: {
        'www/*.html': config.prefix(config.jsfiles, config.localPublic)
      }
    },
    devCssJade: {
      options: {
        startTag: '<!-- STYLES-->',
        endTag: '<!-- STYLES END-->',
        fileTmpl: "<link rel='stylesheet' href='" + config.serverPath + "%s'/>",
        appRoot: config.localPublic + '/'
      },
      files: {
        'www/*.html': config.prefix(config.cssfiles, config.localPublic)
      }
    },
    prodCssJade: {
      options: {
        startTag: '<!-- STYLES-->',
        endTag: '<!-- STYLES END-->',
        fileTmpl: '<link rel="stylesheet" href="%s"/>',
        appRoot: 'www/'
      },
      files: {
        'www/*.html':'www/css/styles.min.css'
      }
    },
    prodJsJade: {
      options: {
        startTag: '<!-- SCRIPTS-->',
        endTag: '<!-- SCRIPTS END-->',
        fileTmpl: "<script type='text/javascript' src='%s'></script>",
        appRoot: 'www/'
      },
      files: {
        'www/*.html': 'www/js/script.min.js'
      }
    }
  });
  grunt.loadNpmTasks('grunt-sails-linker');
};