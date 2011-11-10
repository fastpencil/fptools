module Itext
  class CropMarksGenerator
    class << self

      def mark(in_file, out_file, options={})
        default_options = {
          :margin_width      => 36,
          :margin_height     => 36,
          :top_bleed         => 0,
          :right_bleed       => 0,
          :bottom_bleed      => 0,
          :left_bleed        => 0,
          :crop_mark_backoff => 10,
          :crop_gutter       => false
        }
        options = default_options.update(options)

        orig = Java::ComItextpdfTextPdf::PdfReader.new(in_file)
        orig_dims = orig.getPageSizeWithRotation(1)

        w = (orig_dims.width + (options[:margin_width] * 2))
        h = (orig_dims.height + (options[:margin_width] * 2))

        unless options[:crop_gutter]
          w += options[:right_bleed]
        end

        doc_dims = Java::ComItextpdfText::Rectangle.new(w, h)
        output = Java::ComItextpdfText::Document.new(doc_dims, 0, 0, 0, 0)
        writer = Java::ComItextpdfTextPdf::PdfWriter.getInstance(output,
                                                                 java.io.FileOutputStream.new(out_file))
        writer.setPDFXConformance(1)

        output.open

        orig_pages = orig.getNumberOfPages

        if orig_pages == 1 # do not stagger
          cb = writer.getDirectContent

          insert_marks(cb, w, h, options)

          page = writer.getImportedPage(orig, 1)
          page_rotation = (0 - orig.getPageRotation(1))
          img = Java::ComItextpdfText::Image.java_send(:getInstance,
                                                       [Java::ItextpdfTextPdf::PdfTemplate],
                                                       page)
          img.setRotationDegrees(page_rotation)
          img.setAbsolutePosition(options[:margin_width].to_f,
                                  options[:margin_height].to_f)

          cb.addImage(img)
        else
          1.upto(orig_pages) do |page_num|
            if page_num > 1
              output.newPage
            end

            cb = writer.getDirectContent

            insert_marks(cb, w, h, options)

            x_pos = crop_gutter ?
              options[:margin_width] : ((page_num % 2 == 0) ? options[:margin_width] :
                                        (options[:margin_width] + options[:right_bleed]))

            page = writer.getImportedPage(orig, page_num)
            page_rotation = (0 - orig.getPageRotation(page_num))
            img = Java::ComItextpdfText::Image.java_send(:getInstance,
                                                         [Java::ComItextpdfTextPdf::PdfTemplate],
                                                         page)
            img.setRotationDegrees(page_rotation)
            img.setAbsolutePosition(x_pos.to_f, options[:margin_width].to_f)

            cb.addImage(img)
          end
        end

        output.close

        out_file
      end

      protected

      def insert_marks(cb, w, h, options)
        top_bleed_margin    = options[:margin_width] + options[:top_bleed]
        right_bleed_margin  = options[:margin_width] + options[:right_bleed]
        bottom_bleed_margin = options[:margin_width] + options[:bottom_bleed]
        left_bleed_margin   = options[:margin_width] + options[:left_bleed]
        mark_backoff        = options[:crop_mark_backoff]

        cb.resetCMYKColorStroke
        cb.setLineWidth(0)

        # bottom left
        cb.moveTo(0, bottom_bleed_margin)
        cb.lineTo((left_bleed_margin - mark_backoff), bottom_bleed_margin)
        cb.stroke
        cb.moveTo(left_bleed_margin, (bottom_bleed_margin - mark_backoff))
        cb.lineTo(left_bleed_margin, 0)
        cb.stroke

        # bottom right
        cb.moveTo(w, bottom_bleed_margin)
        cb.lineTo(((w - right_bleed_margin) + mark_backoff), bottom_bleed_margin)
        cb.stroke
        cb.moveTo((w - right_bleed_margin), (bottom_bleed_margin - mark_backoff))
        cb.lineTo((w - right_bleed_margin), 0)
        cb.stroke

        # top left
        cb.moveTo(0, (h - top_bleed_margin))
        cb.lineTo((left_bleed_margin - mark_backoff), (h - top_bleed_margin))
        cb.stroke
        cb.moveTo(left_bleed_margin, ((h - top_bleed_margin) + mark_backoff))
        cb.lineTo(left_bleed_margin, h)
        cb.stroke

        # top right
        cb.moveTo(w, (h - top_bleed_margin))
        cb.lineTo(((w - right_bleed_margin) + mark_backoff), (h - top_bleed_margin))
        cb.stroke
        cb.moveTo((w - right_bleed_margin), ((h - top_bleed_margin) + mark_backoff))
        cb.lineTo((w - right_bleed_margin), h)
        cb.stroke
      end

    end
  end
end

