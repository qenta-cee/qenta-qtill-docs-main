#######################################
## Wrapper to pass attributes to Antora
## Sources:
## - attributes.yml
## - ENV
## ENV vars will be prefixed with ENV_
## ENV which start with values in ignore_environment are ignored
#######################################

require 'yaml'
require 'optparse'
require 'pathname'

@attributes_filename = 'attributes.yml'
@ignore_environment = %w[PATH VSCODE_ GITHUB_ _]

def get_attributes_file
  playbook_file = ARGV.last
  begin
    playbook = YAML.safe_load(File.read(playbook_file))
  rescue StandardError => e
    puts "Error in attributes file: #{playbook_file}"
    puts e.inspect
    exit 1
  end
  # get content path from playbook
  content_path = Pathname.new(File.dirname(playbook['content']['sources'].first['start_paths'].first)).children.select do |c|
    c.directory?
  end.first.to_s

  File.join(content_path, @attributes_filename)
end

def get_env_array
  ENV.to_a.compact.select do |k, v|
    !k.start_with?(*@ignore_environment) && !v.nil?
  end.map do |k, v|
    ["ENV_#{k}", v]
  end
end

def get_attributes_array
  begin
    attributes_file = get_attributes_file
    attributes = YAML.safe_load(File.read(attributes_file)).to_a
  rescue StandardError => e
    puts "Error in attributes file: #{attributes_file}"
    puts e.inspect
    exit 1
  end

  attributes
end

def cli_args
  environment = get_env_array
  attributes = get_attributes_array
  (environment + attributes).compact.map do |k, v|
    "--attribute '#{k}=\"#{v}\"'" unless v.nil?
  end.join(' ')
end

passthrough_args = ARGV[1..-1].join(' ') unless ARGV[1..-1].nil?

command = "antora #{cli_args} #{passthrough_args}"

puts command

#exec command
