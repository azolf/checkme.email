require 'active_record'
require 'yaml'

module Checkme
  module Models
    class Base < ActiveRecord::Base
      primary_abstract_class

      if Checkme.statefull?
        ActiveRecord::Base.establish_connection(Checkme.db_config)
      end
    end
  end
end
