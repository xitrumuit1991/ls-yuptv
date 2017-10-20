module.exports = function (grunt) {
  grunt.registerTask ('prepareAssest',[
    'clean:public',
    'coffee:compile',
    'jade:templates',
    'jade:index',
    'jade:countdown',
    'sass:convert',
    'copy:assets',
    'jst:convert'
  ]);
};
