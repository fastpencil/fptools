require 'fptools'
require 'minitest/autorun'

class TestBarcodeGenerator < MiniTest::Unit::TestCase
  def setup
    @bg = Fptools::Pdf::BarcodeGenerator.new
    @test_number = '9783161484100'
    FileUtils.mkdir_p 'tmp'
  end

  def test_pdf_generation
    test_file = File.expand_path('tmp/test_file.pdf')
    File.delete(test_file) if File.exists?(test_file)
    @bg.pdf(test_file, @test_number)
    assert File.exists?(test_file)
    `open #{test_file}`
    # File.delete(test_file)
  end
end
