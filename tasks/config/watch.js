watchFiles = [
  'app/**/*'
];

module.exports = function (grunt) {

  grunt.config.set('watch', {
    assets: {
      // Assets to watch:
      files: ['app/assets/**/*', '!app/assets/**/*.scss'],
      // When assets are changed:
    },
    sass: {
      // Assets to watch:
      files: ['app/**/*.scss', 'paymentforapp/assets/css/**/*.scss'],
      // When assets are changed:
      tasks: ['sass']
    },
    coffee: {
      // Assets to watch:
      files: ['app/**/*.coffee'],
      // When assets are changed:
      tasks: ['coffee']
    },
    jade: {
      // Assets to watch:
      files: ['app/**/*.jade'],
      // When assets are changed:
      tasks: ['jade', 'pre-sails-linker']
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
};
