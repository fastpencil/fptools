module Itext
  class GutterGenerator

    def self.generate(in_file, out_file)
      gutter_width = 9

      orig = Java::ComItextpdfTextPdf::PdfReader.new(in_file)
      orig_dims = orig.getPageSizeWithRotation(1)

      page_width = orig_dims.getWidth
      page_height = orig_dims.getHeight

      doc_dims = Java::ComItextpdfText::Rectangle.new(page_width, page_height)
      output = Java::ComItextpdfText::Document.new(doc_dims, 0, 0, 0, 0)
      writer = Java::ComItextpdfTextPdf::PdfWriter.getInstance(output,
                                                               java.io.FileOutputStream.new(out_file))
      writer.setPDFXConformance(1)
      output.open

      orig_pages = orig.getNumberOfPages

      1.upto(orig_pages) do |page_num|
        gutter_position = (page_num % 2 == 0) ? :left : :right
        x, y, x1, y1 = (gutter_position == :left) ?
          [(page_width - gutter_width), 0, page_width, page_height] :
          [0, 0, gutter_width, page_height]

        unless page_num == 1
          output.setPageSize(orig.getPageSizeWithRotation(page_num))
          output.newPage
        end

        cb = writer.getDirectContent
        page = writer.getImportedPage(orig, page_num)
        cb.addTemplate(page,0,0)
        cb.setCMYKColorStroke(0,0,0,0)
        cb.setCMYKColorFill(0,0,0,0)
        cb.rectangle(x,y,x1,y1)
        cb.fillStroke
      end

      output.close

      out_file
    end

  end
end

