module.exports = function (grunt) {
  grunt.registerTask('prepareProd', [
    'autoprefixer:dev',
    'concat:jsFiles',
    'concat:cssFiles',
    'uglify:minFile',
    'cssmin:dist'
  ]);
};
