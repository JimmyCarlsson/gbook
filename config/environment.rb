# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'yaml'

yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'application.yml'))).result)
APP_CONFIG = HashWithIndifferentAccess.new(yaml_data)

# Initialize the Rails application.
Rails.application.initialize!
