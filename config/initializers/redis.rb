## Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

redis_ip = Base.find_by_key("app_redis_server_ip", "127.0.0.1")
redis_port = Base.find_by_key("app_redis_server_port", "6379")

$redis = Redis.new(:host => redis_ip, :port => redis_port)