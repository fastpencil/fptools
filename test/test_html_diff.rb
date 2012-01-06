require 'fptools'
require 'minitest/autorun'

class TestHtmlDiff < MiniTest::Unit::TestCase
  def test_diff_of_two_strings
    str1 = <<-EOF
<html>
<body>
<p>Hello!</p>
</body
</html>
    EOF

    str2 = <<-EOF
<html>
<body>
<p>Hello, <strong>Bob</strong>!</p>
</body
</html>
    EOF

    result_str = %(<?xml version="1.0" encoding="utf-8"?><diffreport><diff><p>Hello<span class="diff-html-added" id="added-diff-0" previous="first-diff" changeId="added-diff-0" next="last-diff">, </span><strong><span class="diff-html-added" previous="first-diff" changeId="added-diff-0" next="last-diff">Bob</span></strong>!</p></diff></diffreport>)

    assert_equal Fptools::Html::Diff.strings(str1,str2), result_str
  end
end
