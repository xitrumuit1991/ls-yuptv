config = require('../config.js');
module.exports = function (grunt) {
  grunt.config.set('copy', {
    assets: {
      files: [
        {
          expand: true,
          cwd: 'app/assets',
          src: ['**/*', '!**/*.scss'],
          dest: 'www'
        }
      ]
    },
    healthCheck: {
      files: [
        {
          expand: true,
          cwd: './',
          src: ['health_check'],
          dest: 'www'
        }
      ]
    }

  });

  grunt.loadNpmTasks('grunt-contrib-copy');
};
