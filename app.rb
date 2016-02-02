require 'sinatra'
require 'redis/objects'
require 'haml'

redis_host = ENV['REDIS_HOST'] || '127.0.0.1'
Redis.current = Redis.new(:host => redis_host, :port => 6379)

get '/' do
  counter = Redis::Counter.new('page_views')
  @views = counter.increment
  haml :index
end

get '/reset' do
  counter = Redis::Counter.new('page_views')
  counter.reset
  redirect '/'
end
