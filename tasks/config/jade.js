config = require('../config.js');
var list = {};
list['www/index.html'] = ["app/index.jade"];
module.exports = function (grunt) {
  grunt.config.set('jade', {
    templates: {
      options: {
        pretty: true
      },
      files: [
        {
          expand: true,
          cwd: 'app/views',
          src: ['**/*.jade'],
          dest: 'www/templates',
          ext: '.html'
        }
      ]
    },
    index: {
      options: {
        pretty: true
      },
      files: {
        'www/index.html': ["app/views/layout/index.jade"]
      }
    }
  })
  ;
  grunt.loadNpmTasks('grunt-contrib-jade');
};
