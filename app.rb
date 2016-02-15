require 'sinatra'
require 'redis/objects'
require 'haml'

redis_host = ENV['REDIS_HOST'] || '127.0.0.1'
Redis.current = Redis.new(:host => redis_host, :port => 6379)

get '/' do
  begin
    counter = Redis::Counter.new('page_views')
    @views = counter.increment
    haml :index
  rescue Redis::CannotConnectError
    'Could not connect to Redis. Make sure Redis is running and set ' +
    'REDIS_HOST if Redis is not on localhost.'
  end

end

get '/reset' do
  counter = Redis::Counter.new('page_views')
  counter.reset
  redirect '/'
end
