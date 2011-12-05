require 'tempfile'

class BarcodeGenerator

  # Creates a new BarcodeGenerator.
  #
  # Options:
  #   :number - Number to be rendered in EAN-13 (13 or 13+5)
  def initialize(options={})
    config_file = generate_config_file(options)
    @builder    = Java::OrgApacheAvalonFrameworkConfiguration::DefaultConfigurationBuilder.new
    @config     = @builder.build_from_file(java.io.File.new(config_file.path))
    @generator  = Java::OrgKrysalisBarcode4j::BarcodeUtil.get_instance().create_barcode_generator(@config)
    @message    = options.delete(:number)
    self
  ensure
    config_file.unlink if config_file
  end

  # Generates EPS version of barcode.
  def generate_eps(filename)
    out = java.io.FileOutputStream.new(java.io.File.new(filename))
    provider = Java::OrgKrysalisBarcode4jOutputEps::EPSCanvasProvider.new(out, 0)
    @generator.generate_barcode(provider, @message)
    provider.finish
    filename
  end

  # Generates PNG version of barcode.
  # May not be supported in headless environments.
  def generate_png(filename)
    out = java.io.FileOutputStream.new(java.io.File.new(filename))
    provider = Java::OrgKrysalisBarcode4jOutputBitmap::BitmapCanvasProvider.new(out, "image/x-png", 300, java.awt.image.BufferedImage::TYPE_BYTE_GRAY, true, 0)
    @generator.generate_barcode(provider, @message)
    provider.finish
    filename
  end

  private

  def generate_config_file(options={})
    config_file = Tempfile.open(['barcode_config','xml'])
    config_file.write <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<barcode message="#{@message}">
  <ean13>
    <module-width>0.4mm</module-width>
  </ean13>
</barcode>
    EOF
    config_file.close
    config_file
  end
end

# Example of EAN-13 config.
# <barcode>
#   <ean-13>
#     <height>{length:15mm}</height>
#     <module-width>{length:0.33mm}</module-width>
#     <quiet-zone enabled="{boolean:true}">{length:10mw}</quiet-zone>
#     <checksum>{checksum-mode:auto=add|check}</checksum>
#     <human-readable>
#       <placement>{human-readable-placement:bottom}</placement>
#       <font-name>{font-name:Helvetica}</font-name>
#       <font-size>{length:8pt}</font-size>
#     </human-readable>
#   </ean-13>
# </barcode>

