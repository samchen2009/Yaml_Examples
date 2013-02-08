require 'yaml'
require 'erb'


#base = YAML.load(IO.read("overide.yml"))
#erb = ERB.new(IO.read("myconfig.yml")).result
#puts YAML::load(erb)

def compile_yaml(file)
  text = ""
  path = File.dirname(File.absolute_path(file))
  File.open(file) do |f|
    f.each_line do |line|
      match = /.*!include\s+"(.*?)"\s*/.match(line)
      if !match.nil? and !match[1].nil?
        text << compile_yaml("#{path}/#{match[1]}")
      else
        text << line
      end
    end
    return text
  end
end

text = ""
text =  compile_yaml("myconfig.yml")
puts text
data = YAML::load(text)
puts "data = #{data}"

context = data["default"]
puts "context ="
puts context
template = ERB.new(context.to_yaml);
puts "template = "
puts template
default_config = YAML::load(template.result(binding))
#while /<%=.*%>/.match(default_config) != nil
#  default_config = ERB.new(default_config).result(binding)
#end

puts default_config
#puts config['build']["build_cmd"]

