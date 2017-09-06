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
          cwd: 'paymentforapp/assets/css',
          src: ['**/*.scss'],
          dest: 'paymentforapp/assets/css',
          ext: '.css'
        }
      ]
    }
  });

  grunt.loadNpmTasks('grunt-contrib-sass');
};
