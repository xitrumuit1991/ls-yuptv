module.exports = function (grunt) {
  grunt.config.set('autoprefixer', {
    options: {
      browsers: ['opera 12', 'ff 15', 'chrome 25'],
      diff: 'www/css/main'

    },
    dev: {
      src: 'www/css/main.css',
      dest: 'www/css/main.css'
    }
  });

  grunt.loadNpmTasks('grunt-autoprefixer');
};
