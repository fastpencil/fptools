require 'fptools'
require 'minitest/autorun'

class TestEpubValidator < MiniTest::Unit::TestCase
  def setup
    @ev = Fptools::Epub::EpubValidator.new
    @good_epub = File.expand_path(File.join(File.dirname(__FILE__),'examples','valid_epub.epub'))
    @bad_epub = File.expand_path(File.join(File.dirname(__FILE__),'examples','invalid_epub.epub'))
  end

  def test_good_epub_validation
    assert @ev.validate(@good_epub)
    assert_empty @ev.report.errors
    assert_empty @ev.report.warnings
  end

  def test_bad_epub_validation
    refute @ev.validate(@bad_epub)
    refute_empty @ev.report.errors
  end
end
