###YUP
# Instruction for the frontend app installation:

#### config in config_server.js
- redis
- url api; api_secrect_key & api_base_url
- google captcha; web_SITE_KEY & web_SECRET_KEY
- port

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
* NODE_ENV=development grunt pre-dev (run in the first time init app)
* pm2 start app.js -n livestar-web-v2-5002


#### To deploy production, auto minify & uglify & concat all codes:
* npm install  (everytime deploy code)
* NODE_ENV=production grunt prod
* pm2 start app.js -n livestar-web-v2-5002


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



