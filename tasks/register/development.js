module.exports = function (grunt) {
  grunt.registerTask('pre-sails-linker', [
    'jst',
    'sails-linker:devJsJade',
    'sails-linker:devCssJade'
  ]);

  grunt.registerTask('pre-dev', [
    'prepareAssest',
    'pre-sails-linker'
  ]);
  grunt.registerTask('dev', [
    'pre-dev',
    'express:dev',
    'watch'
  ]);
};
