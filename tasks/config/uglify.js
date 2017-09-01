config = require('../config.js');

module.exports = function (grunt) {
  pkg = grunt.file.readJSON('package.json');
  grunt.config.set('uglify', {

    minFile: {
      options: {
        compress: {
          drop_console: ((process.env.ENV == 'dev') ? false : true)
        },
        mangle:true,
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today("dd-mm-yyyy") %> */'
      },
      files: {
        'www/js/script.min.js': ['www/js/script.min.js']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
};
