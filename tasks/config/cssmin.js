module.exports = function (grunt) {

  grunt.config.set('cssmin', {
    dist: {
      src: [config.localPublic + '/css/styles.min.css'],
      dest: config.localPublic + '/css/styles.min.css'
    }
  });

  grunt.loadNpmTasks('grunt-contrib-cssmin');
};
