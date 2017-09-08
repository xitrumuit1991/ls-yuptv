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
    }
  });

  grunt.loadNpmTasks('grunt-contrib-copy');
};
