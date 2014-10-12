require "logstash/filters/base"

class LogStash::Filters::Docker < LogStash::Filters::Base
 config_name "docker"
 milestone 1

 public
 def initialize(config = {})
  super
  @cache = Hash.new
 end

 public
 def register
  require 'json'
  require 'excon'
 end

 public
 def filter(event)
  return unless filter?(event)

  id = event["file"].split('/').last(2).first
  if @cache[id]
    image_name = @cache[id]
  else
    con = Excon.new("unix:///", {:socket => "/var/run/docker.sock"})
    containers = JSON.load(con.get(:path => "/v1.14/containers/json?all=1").body)
    container = containers.index{|b| b["Id"] == id}
    if container
       image_name = containers.at(container)["Names"].at(0)
    else
       image_name = "unknwon"
    end
    @cache[id] = image_name
  end
  event["container"] = image_name
  filter_matched(event)
 end
end

