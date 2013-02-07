require 'yaml'
require 'json'
require 'crack'
#require 'rexml/document'
YAML::ENGINE.yamler='syck'

def hash_utf8(hash)
  if hash.is_a?(String)
    hash = hash.force_encoding("UTF-8")
  elsif hash.is_a?(Hash)
    hash.each_pair {|k,v| hash_utf8(v)}
  end
  return hash
end

def string_to_list(hash)
  #puts "before: hash = #{hash}"
  if hash.is_a?(String)
    str = hash.strip
    return str.include?("\n") ? str.split("\n").map{|x| x.strip} : str
  elsif hash.is_a?(Hash)
    new_hash = {}
    hash.each_pair {|k,v| new_hash[k] = string_to_list(v)}
    return new_hash
  end
end

def recursive(hash)
end

if ($0 == __FILE__)
  usage = "usage: ruby xml2yaml.rb path/to/*.xml [json or yaml]"

  if (!ARGV[0])
    puts usage
    exit 1
  end

  filelist = []

  if Dir.exist?(ARGV[0])
    xmlfiles = File.join("#{ARGV[0]}/**","*.xml")
    filelist = Dir.glob(xmlfiles)
  else
    filelist << ARGV[0]
  end

  type = ARGV[1] ? ARGV[1] : "yml"
  puts filelist

  filelist.each do |f|
    hash = Crack::JSON.parse(Crack::XML.parse(File.read("./#{f}")).to_json)
    hash = string_to_list(hash)
    out = (type == "yml") ? hash.to_yaml : hash.to_json
    File.open("./#{File.basename(f,'.xml')}.#{type}","w") do |file|
    #File.open("./1.yml","w") do |file|
      file.write(out)
      puts ("convert #{f} -->  #{type}")
    end
  end
end
