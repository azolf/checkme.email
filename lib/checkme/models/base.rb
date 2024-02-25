require 'active_record'
require 'yaml'

module Checkme
  module Models
    class Base < ActiveRecord::Base
      primary_abstract_class
      db_config_file = File.open('db/config.yml')
      db_config = YAML::load(db_config_file)

      ActiveRecord::Base.establish_connection(db_config[ENV['APP_ENV']])
    end
  end
end
