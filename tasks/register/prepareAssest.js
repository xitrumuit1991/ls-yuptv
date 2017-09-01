module.exports = function (grunt) {
  grunt.registerTask ('prepareAssest',[
    'clean:public',
    'coffee:compile',
    'jade:templates',
    'jade:index',
    'sass:convert',
    'copy:assets',
    'jst:convert'
  ]);
};
