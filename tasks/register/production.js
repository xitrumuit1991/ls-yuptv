module.exports = function (grunt) {
  grunt.registerTask('prod', [
    'prepareAssest',
    'prepareProd',
    'sails-linker:prodJsJade',
    'sails-linker:prodCssJade',
    'copy:healthCheck'
  ]);
};
