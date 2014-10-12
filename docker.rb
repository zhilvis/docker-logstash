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
  container = containers.index{|b| b["Id"] == id}
  if container
    image_name = containers.at(container)["Names"].at(0)
    event["container"] = image_name
  else
    event["container"] = "unknown"
  end
  filter_matched(event)
 end
end

