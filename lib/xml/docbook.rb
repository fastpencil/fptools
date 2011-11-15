require 'nokogiri'

module Xml
  class Docbook
    SCHEMA_FILENAME = File.join(File.dirname(__FILE__),'..','..','vendor','docbook','docbook.rng')

    def self.validate(file)
      driver    = vd.new
      schema_is = vd.file_input_source(SCHEMA_FILENAME)
      target_is = vd.file_input_source(file)
      driver.load_schema(schema_is)
      driver.validate(target_is)
    end

    def self.vd
      Java::ComThaiopensourceValidate::ValidationDriver
    end
  end
end
