module Fptools
  module Pdf
    class PdfMerge
      include_package 'com.itextpdf.text'
      include_package 'com.itextpdf.text.pdf'

      def self.merge(input_files, output_file)
        output_stream = java.io.FileOutputStream.new(output_file)
        copy = PdfCopyFields.new(output_stream)

        input_files.each do |f|
          reader = PdfReader.new(f)
          copy.addDocument(reader)
        end

        copy.close

        output_file
      end

    end
  end
end
