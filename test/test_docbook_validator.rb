require 'fptools'
require 'minitest/autorun'

class TestDocbookValidator < MiniTest::Unit::TestCase
  def setup
    @dv = Fptools::Xml::DocbookValidator.new
    @good_doc = File.expand_path(File.join(File.dirname(__FILE__),'examples','valid_docbook.xml'))
    @bad_doc = File.expand_path(File.join(File.dirname(__FILE__),'examples','invalid_docbook.xml'))
  end

  def test_errors_is_empty_after_init
    assert_nil @errors
  end

  def test_validation_of_good_document
    assert @dv.validate(@good_doc)
  end

  def test_validation_blanks_errors
    @dv.validate(@good_doc)
    assert_nil @dv.errors
  end

  def test_validation_of_bad_document
    refute @dv.validate(@bad_doc)
  end

  def test_failed_validation_populates_errors
    @dv.validate(@bad_doc)
    refute_nil @dv.errors
  end
end

