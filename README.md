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

#### WINDOW To deploy development, auto minify & uglify & concat all codes:
* set ENV=dev&  grunt dev



#### paymentforapp folder (include css/js/ejs/controller) is template for app Android/IOS payment
* it render from server (render html/css/js)
* view engine is ejs
* session connect redis
* use token to call API payment


#### app folder is angular application. It will be complie to www folder.
* express will be load from www folder and angular init application
* www include css/js/template/angular core
* * view engine is jade
* grunt config in tasks/
* please type cmd  "grunt dev"  to dev mode ( also remember run redis)



