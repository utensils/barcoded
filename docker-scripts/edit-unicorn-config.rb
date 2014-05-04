#!/usr/bin/env ruby
# This script is used to read a unicorn configuration file into memory
# Update values based on ENV variables and write it back to disk.

CONFIG_FILE = '/home/barcoded/unicorn.rb'

ENV_CONFIG_OPTIONS = {
        'UNICORN_WORKERS' => 'worker_processes',
        'UNICORN_TIMEOUT' => 'timeout',
        'UNICORN_BACKLOG' => 'backlog'
    } 

def print_header(string)
    puts '=' * 80
    puts string
    puts '=' * 80
end

def parse_env_variables
  options = {}
  ENV_CONFIG_OPTIONS.each do |env_variable,option|
    if ENV[env_variable]
      puts "#{option} value: #{ENV[env_variable]}"
      options[option] = ENV[env_variable]
    else
      puts "Could not find #{ENV[env_variable]}"
    end
  end
  return options
end

def read_config_file(input_file)
  contents = []
  file = nil
  begin
    file = File.open(input_file).each_line{|line| contents.push(line)}
  rescue => e
    puts e.message
    return nil
  ensure
    file.close unless file.nil?
  end
  return contents
end

def write_config_file(contents,output_file)
  file = nil
  begin
    file = File.open(output_file,'w')
    contents.each {|line| file.puts line}
  rescue => e
    puts e.message
    return false
  ensure
    file.close unless file.nil?
  end
  return true
end

def update_config_options(contents,options)
  new_contents = []
  regex = /^(\w+)\s+\S.*$/
  contents.map! do |line|
    match = line.match(regex)
    match.nil? ? option = nil : option = match[1]
    if option
      new_contents.push("#{option} #{options[option]}") if options.has_key?(option)
    else
      new_contents.push(line)
    end
  end
  return new_contents
end

# Update the configuration
print_header 'Updating Unicorn configuration'
config_options = parse_env_variables
if (config_contents = read_config_file(CONFIG_FILE))
  new_contents = update_config_options(config_contents,config_options)
  if (write_config_file(new_contents,CONFIG_FILE))
    print_header 'Configuration updated!'
  else
    print_header 'Problem updating config'
    exit 1
  end
else
  print_header 'Problem reading config'
  exit 1
end
