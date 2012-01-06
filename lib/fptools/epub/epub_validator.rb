
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
    class EpubValidator
      attr_reader :report

      def validate(file)
        @report = Report.new
        file = java.io.File.new(file)
        epubcheck = Java::ComAdobeEpubcheckApi::EpubCheck.new(file, @report)
        epubcheck.validate
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
