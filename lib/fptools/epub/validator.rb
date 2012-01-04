
# Wraps the epubcheck validator to... check epub files for validity.
#
# Example usage:
#   f = File.join(current_path,'PorridgeBook.epub')
#   validator = Epub::Validator.new(f)
#   validator.validate (returns true or false)
#
# Errors and warnings are stored in
#   validator.report.errors
#   validator.report.warnings
#
module Fptools
  module Epub
    class Validator
      def initialize(file)
        @file = java.io.File.new(file)
      end

      def validate
        @errors   = []
        epubcheck = Java::ComAdobeEpubcheckApi::EpubCheck.new(@file, self.report)
        valid     = epubcheck.validate
      end

      def report
        @report ||= Report.new
      end

      class Report
        include Java::ComAdobeEpubcheckApi::Report

        attr_reader :errors, :warnings

        def initialize
          @errors   = []
          @warnings = []
        end

        def error(resource, line, message)
          @errors << [resource, line, message]
        end

        def warning(resource, line, message)
          @warnings << [resource, line, message]
        end
      end
    end
  end
end
