require 'nokogiri'

module Fptools
  module Xml
    class DocbookValidator
      java_import com.thaiopensource.validate.ValidationDriver
      java_import com.thaiopensource.util.PropertyMapBuilder
      java_import com.thaiopensource.xml.sax.DraconianErrorHandler
      java_import com.thaiopensource.validate.ValidateProperty
      java_import org.xml.sax.SAXParseException

      SCHEMA_FILENAME = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','vendor','docbook','docbook.rng'))

      attr_reader :errors

      def validate(file)
        @errors = nil
        vd = self.class.validation_driver
        target = ValidationDriver.file_input_source(file)
        begin
          vd.validate(target)
          true
        rescue SAXParseException => ex
          @errors = ex.message
          false
        end
      end

      protected

      def self.validation_driver
        return @validation_driver if @validation_driver
        deh = DraconianErrorHandler.new
        builder = PropertyMapBuilder.new
        builder.put(ValidateProperty::ERROR_HANDLER, deh)
        driver = ValidationDriver.new(builder.to_property_map)
        schema = ValidationDriver.file_input_source(SCHEMA_FILENAME)
        driver.load_schema(schema)
        @validation_driver = driver
      end
    end
  end
end
