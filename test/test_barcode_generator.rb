require 'fptools'
require 'minitest/autorun'

class TestBarcodeGenerator < MiniTest::Unit::TestCase
  def setup
    @bg = Fptools::BarcodeGenerator.new
    @test_number = '9783161484100'
    FileUtils.mkdir_p 'tmp'
  end

  def test_eps_generation
    test_file = 'tmp/test_file.eps'
    File.delete(test_file) if File.exists?(test_file)
    @bg.generate_eps(test_file, @test_number)
    assert File.exists?(test_file)
    # `open #{test_file}`
    File.delete(test_file)
  end

  def test_png_generation
    test_file = 'tmp/test_file.png'
    File.delete(test_file) if File.exists?(test_file)
    @bg.generate_png(test_file, @test_number)
    assert File.exists?(test_file)
    # `open #{test_file}`
    File.delete(test_file)
  end
end
