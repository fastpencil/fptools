require 'tempfile'

module Fptools
  module Html
    class Diff
      import java.util.Locale
      import javax.xml.transform.sax.SAXTransformerFactory
      import javax.xml.transform.stream.StreamResult
      import org.xml.sax.InputSource
      import org.xml.sax.helpers.AttributesImpl
      import org.outerj.daisy.diff
      import org.outerj.daisy.diff.html
      import org.outerj.daisy.diff.html.dom

      class << self
        def strings(str1,str2)
          in1 = java.io.ByteArrayInputStream.new(str1.to_java_string.getBytes("UTF-8"))
          in2 = java.io.ByteArrayInputStream.new(str2.to_java_string.getBytes("UTF-8"))
          out = java.io.ByteArrayOutputStream.new
          differ = self.new in1, in2, out
          differ.process!
          out.toString.to_s
        end
      end

      def initialize(in1,in2,out)
        @in1 = in1
        @in2 = in2
        @out = out
      end

      def process!
        handler = self.handler(@out)
        diff_output = HtmlSaxDiffOutput.new(handler,"diff")
        differ = HTMLDiffer.new(diff_output)
        handler.startDocument()
        handler.startElement("","diffreport","diffreport",AttributesImpl.new())
        handler.startElement("","diff","diff",AttributesImpl.new())
        differ.diff(comparator(@in1),comparator(@in2))
        handler.endElement("","diff","diff")
        handler.endElement("","diffreport","diffreport")
        handler.endDocument()
      end

      def handler(output)
        handler = SAXTransformerFactory.newInstance.newTransformerHandler
        handler.setResult(StreamResult.new(output))
        handler
      end

      def comparator(input)
        builder = DomTreeBuilder.new
        cleaner = HtmlCleaner.new
        cleaner.cleanAndParse(InputSource.new(input),builder)
        TextNodeComparator.new(builder,locale)
      end

      def locale
        Locale.getDefault()
      end
    end
  end
end
