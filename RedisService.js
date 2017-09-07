var ioredis = require("ioredis");
var client = null;
var config_server = require("./config_server");
var ConfigOptionsRedis = config_server.redis;

module.exports = {
  init: function(done) {
    done = done || function(){};
    if(ConfigOptionsRedis.isCluster == true)
    {
      client = new ioredis.Cluster([{host: ConfigOptionsRedis.host, port: ConfigOptionsRedis.port }]);
    }
    else{
      client = new ioredis({ host: ConfigOptionsRedis.host, port: ConfigOptionsRedis.port});
    }

    if (ConfigOptionsRedis.password) {
      client.auth(ConfigOptionsRedis.password, function(err) {
        if (err) { return done(false); }
      });
    }
    client.on('connect', function() {
      return client.select(ConfigOptionsRedis.database, function(err) {
        if (err) {
          console.info("Could not connect Redis... " + err);
          return done(false);
        }
        console.info("Connected Redis [" + ConfigOptionsRedis.database + "] ....");
        return done(null);
      });
    });
    client.on('error', function(err) {
      console.info("Could not connect Redis... " + err);
      return done(false);
    });
  },
  getClient : function () {
    return client;
  },
  get: function (key, done)
  {
    key = ConfigOptionsRedis.envPrefix + key;
    if (!client) {
      return done(null,null);// return done(null, {error : 1, message : 'Redis not found client'});
    }
    client.get(key, function(err, value)
    {
      if (err) {
        return done(true,
          {
            code: 1000, error: 'Error undefined',key : key,
            log: "[RedisServer.get] ERROR: Could not get... " + err
          });
      }
      if (ConfigOptionsRedis.active) {
        return done(null, value);
      }
      return done(null, null);
    });
  }
  ,

  set : function (key, value, ttl, done) {
    done = done || function(){};
    key = ConfigOptionsRedis.envPrefix + key;
    if (!client) {return done(null,{error : 1, message : 'Redis not found client init' });}
    client.set(key, value, function(err)
    {
      if (err) {
        return done(true,
          {
            code: 1000, key : key, error: 'Error undefined',
            log: "[RedisServer.set] ERROR: Could not set... " + err
          });
      }
      if (ttl) {
        client.expire(key, ttl);
      }
      return done(null, {error : 0, message: 'Redis set key SUCCESS', value : value, key : key});
    });
  },


  del : function (key, done)
  {
    done = done || function(){};
    key = ConfigOptionsRedis.envPrefix   + key;
    if (!client) {
      return done(null,{error : 1, message : 'redis client not init' });
    }
    client.del(key, function(err) {
      if (err) {
        return done(true,
          {
            code: 1000, key:key, error: 'Error undefined',
            log: "[RedisServer.del] ERROR: Could not del... " + err
          });
      }
      return done(null,{error: 0, message:'redis del key SUCCESS', key : key});
    });
  }
};