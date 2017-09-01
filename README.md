###YUP
# Instruction for the frontend app installation:

#### If you are installing in root folder:
- Upload everything.
- Install node.js
- Install Ruby + sass
- sudo npm install -g jade grunt-cli coffee-script
- Run "npm install".
- Serve “app” folder as web root.


##### IMPORTANT: You must config server to direct all requests to www/index.html

#### To deploy development, auto minify & uglify & concat all codes:
* npm install && grunt dev (everytime deploy code)
* ENV=local grunt dev (run in the first time init app)


#### To deploy production, auto minify & uglify & concat all codes:
* npm install && ENV=production grunt prod (everytime deploy code)


#### To deploy staging, auto minify & uglify & concat all codes:
* npm install && ENV=staging grunt prod (everytime deploy code)

#### To deploy sandbox, auto minify & uglify & concat all codes:
* npm install && ENV=sandbox grunt prod (everytime deploy code)

#### WINDOW To deploy development, auto minify & uglify & concat all codes:
* set ENV=dev&  grunt dev


