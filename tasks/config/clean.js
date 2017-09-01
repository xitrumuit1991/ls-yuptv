module.exports = function (grunt) {
  grunt.config.set('clean', {
    public: ['www','www'],
    orig :['**/*.orig']
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
};
