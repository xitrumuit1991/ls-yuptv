var config = require('../config.js');
var templateFilesToInject = [
  config.localPublic + '/templates/**/*.html'
];
var list = {};
list[config.localPublic + '/js/templates.js'] = templateFilesToInject;
module.exports = function (grunt) {
  grunt.config.set('jst', {
    options: {
      prettify: true,
      namespace: 'Templates',
      processName: function (filePath) {
        return filePath.replace('www/templates/', '').replace(/(\.html$)/, '').replace(/\//g, '.').replace('.view', '');
      }
    },
    convert: {
      files: list
    }
  });
  grunt.loadNpmTasks('grunt-contrib-jst');
};
