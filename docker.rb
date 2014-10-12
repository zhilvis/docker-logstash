require 'json'
require 'excon'

class LogStash::Filters::Docker < LogStash::Filters::Base
 config_name "docker"
 milestone 2

 public
 def register
        # Nothing to do
 end

 public
 def filter(event)
  con = Excon.new("unix:///", {:socket => "/var/run/docker.sock"})
  containers = JSON.load(con.get(:path => "/v1.14/containers/json?all=1").body)
  id = event["file"].split('/').last(2).first
  image_name = containers.at(containers.index{|b| b["Id"] == id})["Names"].at(0)
  event["container"] = image_name
  filter_matched(event)
 end
end

