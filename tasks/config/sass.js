module.exports = function (grunt) {

  grunt.config.set('sass', {
    convert: {
      options: {
        lineNumbers: true,
        sourceMap:null
      },
      files: [
        {
          expand: true,
          cwd: 'app/assets/css',
          src: ['**/*.scss'],
          dest: 'www/css',
          ext: '.css'
        },
        {
          expand: true,
          cwd: 'assets/css',
          src: ['**/*.scss'],
          dest: 'assets/css',
          ext: '.css'
        }
      ]
    }
  });

  grunt.loadNpmTasks('grunt-contrib-sass');
};
