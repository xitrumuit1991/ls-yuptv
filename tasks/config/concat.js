config = require('../config.js');
var list = {};
var listCss = {};
list[config.localPublic + '/js/script.min.js'] = config.prefix(config.jsfiles, config.localPublic);
listCss[config.localPublic + '/css/styles.min.css'] = config.prefix(config.cssfiles, config.localPublic);
module.exports = function (grunt) {
  grunt.config.set('concat', {
    jsFiles: {
      files: list
    },
    cssFiles: {
      files: listCss
    }
  });

  grunt.loadNpmTasks('grunt-contrib-concat');
};
