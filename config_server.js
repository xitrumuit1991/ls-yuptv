var object = {
  port: 5002,
  api_base_url: 'http://dev.livestar.vn:1010/api/v1/',
  api_secrect_key: "fQ+KY11&l624Bu5",
  // web_SITE_KEY: "6LdVAxkTAAAAAAeES9kxnsXGbKuW3dcrtM2u_NH_",
  // web_SECRET_KEY: "6LdVAxkTAAAAAHBO45vG52ZMogoakzo4wopvuLke",
  ENV :  process.env.NODE_ENV ? process.env.NODE_ENV : 'production',
  redis : {
    port : 6379,
    host: 'localhost',
    secret : '1BCB58514FCE3C7C66BB6C91ACD88',
    envPrefix : 'session:web-v2:development:',
    password: null,
    isCluster: false,
    database: 0,
    options: {
      parser: 'hiredis',
      return_buffers: false,
      detect_buffers: false,
      socket_nodelay: true,
      no_ready_check: false,
      enable_offline_queue: true
    }
  }
};
if( process.env.NODE_ENV == 'production' || process.env.NODE_ENV == 'prod')
{
  // object.api_base_url = 'http://dev.livestar.vn:1010/api/v1/';
  object.api_base_url = 'http://api.yuptv.vn/api/v1/';
  object.redis.host = '10.148.0.5';
  object.redis.database = 2;
  object.redis.isCluster = true;
  object.redis.envPrefix = 'session:web-v2:production:';
  object.ENV = 'production';
}

module.exports = object;