module Fptools
	module Pdf
		# Uses iText's built-in barcode generation.
		class BarcodeGenerator
      include_package 'com.itextpdf.text'
      include_package 'com.itextpdf.text.pdf'

			def pdf(filename,message)
				doc = Document.new(Rectangle.new(340,842))
				writer = PdfWriter.get_instance(doc, java.io.FileOutputStream.new(filename))
        doc.open
				cb = writer.get_direct_content
				doc.add(ean13(message).create_image_with_barcode(cb,nil,nil))
				doc.close
			end

			protected

			def ean13(message)
				message = message.to_s.gsub(/[^\d\+]+/,'').split('+')

				fonts_dir = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','vendor','fonts'))
				font_path = File.join(fonts_dir, 'OCRB.ttf')
        font = BaseFont.create_font(font_path, BaseFont::CP1252, true)

				ean = BarcodeEAN.new
				ean.set_code_type(Barcode::EAN13)
				ean.set_guard_bars(true)
				ean.set_code(message[0])
				ean.set_font(font)
				if message[1]
					ean2 = BarcodeEAN.new
					ean2.set_code_type(Barcode::SUPP5)
					ean2.set_code(message[1])
					ean2.set_baseline(-2)
					ean2.set_font(font)
					BarcodeEANSUPP.new(ean,ean2)
				else
					ean
				end
			end
		end
	end
end
