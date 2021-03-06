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
        },
        {
          expand: true,
          cwd: 'app/core/directive',
          src: ['**/*.jade'],
          dest: 'www/templates/directive',
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
    },
    countdown: {
      options: {
        pretty: true
      },
      files: {
        'www/countdown.html': ["app/views/countdown.jade"]
      }
    },

  })
  ;
  grunt.loadNpmTasks('grunt-contrib-jade');
};
