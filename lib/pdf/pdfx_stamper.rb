module Pdf
  class PdfxStamper

    # Takes an existing PDF file, pads it to a multiple of four, PDF/X stamps
    # it, and places a bar code on the last page.
    #
    # Options:
    #  :pad_file
    #    Pad file pages out to multiple of four, adding FastPencil stamp
    #    to last page. (false)
    #  :bar_code_file
    #    Image file to place on final page of document.  Requires :pad_file to
    #    be true. (nil)
    def self.stamp(orig_file, output_file, options = {})
      default_options = {
        :bar_code_file => nil,
        :pad_file => false
      }
      options = default_options.update(options)

      orig       = Java::ComItextpdfTextPdf::PdfReader.new(orig_file)
      orig_dims  = orig.getPageSizeWithRotation(1)
      orig_pages = orig.getNumberOfPages
      output     = Java::ComItextpdfText::Document.new(orig_dims, 0, 0, 0, 0)
      out_stream = java.io.FileOutputStream.new(output_file)
      writer     = Java::ComItextpdfTextPdf::PdfWriter.getInstance(output, out_stream)

      writer.setPDFXConformance(1)

      output.open

      1.upto(orig_pages) do |page_num|
        if page_num > 1
          output.setPageSize(orig.getPageSizeWithRotation(page_num))
          output.newPage
        end

        page          = writer.getImportedPage(orig, page_num)
        page_rotation = (0 - orig.getPageRotation(page_num))
        page_size     = orig.getPageSizeWithRotation(page_num)

        img = Java::ComItextpdfText::Image.java_send :getInstance,
          [Java::ComItextpdfTextPdf::PdfTemplate], page
        img.setRotationDegrees(page_rotation)

        output.add(img)
      end

      pages_to_add = 0

      if options[:pad_file]
        # Add at least one new page.
        pages_to_add = 1

        # Pad PDF out to a page count multiple of 4.
        pages_to_add += (4 - ((orig_pages + 1) % 4))

        output.setPageSize(orig.getPageSizeWithRotation(1))
        output.setMargins(72, 72, (orig_dims.height/2.0), 72)

        pages_to_add.times do
          writer.setPageEmpty(false)
          output.newPage
        end

        if options[:bar_code_file]
          bar_code_awt = java.awt.AwtToolkit.getDefaultToolkit.createImage(options[:bar_code_file])
          bar_code_image = Java::ComItextpdfText::Image.getInstance(bar_code_awt, nil)
          bar_code_image.scaleToFit(144, 72)
          bar_code_image.setAlignment(Java::ComItextpdfText::Image::ALIGN_CENTER)
          output.add(bar_code_image)
        end

        Java::ComItextpdfText::FontFactory.register 'vendor/fonts/arial.ttf', 'Arial'
        font = Java::ComItextpdfText::FontFactory.getFont('Arial',
                                                          Java::ComItextpdfTextPdf::BaseFont::CP1252,
                                                          Java::ComItextpdfTextPdf::BaseFont::EMBEDDED, 8)
        para = Java::ComItextpdfText::Paragraph.new("Published by FastPencil\nhttp://www.fastpencil.com", font)
        para.setAlignment Java::ComItextpdfText::Paragraph::ALIGN_CENTER
        output.add para
      end

      [output, writer, out_stream].each(&:close)

      [output_file, (orig_pages + pages_to_add)]
    end

  end
end

