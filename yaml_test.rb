require 'yaml'
require 'erb'

#base = YAML.load(IO.read("overide.yml"))
erb = ERB.new(IO.read("myconfig.yml")).result
puts YAML::load(erb)

config = YAML::load(IO.read("ics_example.yml"))
puts config
puts config["config"]['build']["build_cmd"]

