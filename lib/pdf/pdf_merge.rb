module Pdf
  class PdfMerge

    def self.merge(input_files, output_file)
      output_stream = java.io.FileOutputStream.new(output_file)
      copy = Java::ComItextpdfTextPdf::PdfCopyFields.new(output_stream)

      input_files.each do |f|
        reader = Java::ComItextpdfTextPdf::PdfReader.new(f)
        copy.addDocument(reader)
      end

      copy.close

      output_file
    end

  end
end

