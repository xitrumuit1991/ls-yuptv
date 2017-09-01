module.exports = function (grunt) {

  grunt.config.set('sass', {
    convert: {
      options: {
        lineNumbers: true,
        sourceMap:false
      },
      files: [
        {
          expand: true,
          cwd: 'app/assets/css',
          src: ['**/*.scss'],
          dest: 'www/css',
          ext: '.css'
        }
      ]
    }
  });

  grunt.loadNpmTasks('grunt-contrib-sass');
};
