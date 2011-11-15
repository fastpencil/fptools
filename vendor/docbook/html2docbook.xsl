<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:html="http://www.w3.org/1999/xhtml" version="1.0" exclude-result-prefixes="xsl fo html">
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="html:html">
    <xsl:apply-templates select="html:body"/>
  </xsl:template>
  <!-- Export content inside of a section tag.  Add a blank paragraph to make sure we're valid. -->
  <xsl:template match="html:body">
    <section>
      <xsl:apply-templates select="*"/>
      <para/>
    </section>
  </xsl:template>
  <xsl:template match="html:div">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="html:h1">
    <bridgehead renderas="sect1">
      <xsl:apply-templates/>
    </bridgehead>
  </xsl:template>
  <xsl:template match="html:h2">
    <bridgehead renderas="sect2">
      <xsl:apply-templates/>
    </bridgehead>
  </xsl:template>
  <xsl:template match="html:h3">
    <bridgehead renderas="sect3">
      <xsl:apply-templates/>
    </bridgehead>
  </xsl:template>
  <xsl:template match="html:h4">
    <bridgehead renderas="sect4">
      <xsl:apply-templates/>
    </bridgehead>
  </xsl:template>
  <xsl:template match="html:h5">
    <bridgehead renderas="sect5">
      <xsl:apply-templates/>
    </bridgehead>
  </xsl:template>
  <xsl:template match="html:h6">
    <bridgehead renderas="sect5">
      <xsl:apply-templates/>
    </bridgehead>
  </xsl:template>
  <xsl:template match="html:p[contains(@style, 'text-align: justify;')]">
    <para role="justify">
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:p[contains(@style, 'text-align: right;')]">
    <para role="right">
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:p[contains(@style, 'text-align: left;')]">
    <para role="left">
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:p[contains(@style, 'text-align: center;')]">
    <para role="center">
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:p[contains(@style, 'padding-left: 30px;')]">
    <para role="indent1">
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:p[contains(@style, 'padding-left: 60px')]">
    <para role="indent2">
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:p[contains(@style, 'padding-left: 90px')]">
    <para role="indent3">
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:p">
    <para>
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  <xsl:template match="html:pre">
    <programlisting>
      <xsl:apply-templates/>
    </programlisting>
  </xsl:template>
  
  <!-- Hyperlinks -->
  <xsl:template match="html:a[contains(@href,'http://')]" priority="1.5" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">
   <link>
    <xsl:attribute name="xlink:href">
     <xsl:value-of select="normalize-space(@href)"/>
    </xsl:attribute>
    <xsl:apply-templates/>
   </link>
  </xsl:template>

  <xsl:template match="html:a[contains(@href,'ftp://')]" priority="1.5" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">
   <link>
    <xsl:attribute name="xlink:href">
     <xsl:value-of select="normalize-space(@href)"/>
    </xsl:attribute>
    <xsl:apply-templates/>
   </link>
  </xsl:template>

  <!-- I have no idea what this does -->
  <xsl:template name="string.subst">
    <xsl:param name="string" select="''"/>
    <xsl:param name="substitute" select="''"/>
    <xsl:param name="with" select="''"/>
    <xsl:choose>
      <xsl:when test="contains($string,$substitute)">
        <xsl:variable name="pre" select="substring-before($string,$substitute)"/>
        <xsl:variable name="post" select="substring-after($string,$substitute)"/>
        <xsl:call-template name="string.subst">
          <xsl:with-param name="string" select="concat($pre,$with,$post)"/>
          <xsl:with-param name="substitute" select="$substitute"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ========= -->
  <!-- = Lists = -->
  <!-- ========= -->
  <xsl:template match="html:ul">
    <itemizedlist>
      <xsl:choose>
        <xsl:when test="count(html:li) = 0">
          <listitem><para/></listitem>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>      
    </itemizedlist>
  </xsl:template>
  <xsl:template match="html:ol">
    <orderedlist>
      <xsl:choose>
        <xsl:when test="count(html:li) = 0">
          <listitem><para/></listitem>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>      
    </orderedlist>
  </xsl:template>
  <xsl:template match="html:dl">
    <variablelist>
      <xsl:for-each select="html:dt">
        <varlistentry>
          <term>
            <xsl:apply-templates/>
          </term>
          <listitem>
            <xsl:apply-templates select="following-sibling::html:dd[1]"/>
          </listitem>
        </varlistentry>
      </xsl:for-each>
    </variablelist>
  </xsl:template>
  <xsl:template match="html:dd">
    <xsl:call-template name="enclose_with_paras">
      <xsl:with-param name="nodeset" select="."/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="html:li">
    <listitem>
      <xsl:choose>
        <xsl:when test="boolean(html:p)">
          <xsl:if test="count(.//text()) > 0">
            <xsl:call-template name="enclose_with_paras">
              <xsl:with-param name="nodeset" select="."/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <para>
            <xsl:apply-templates />
          </para>
        </xsl:otherwise>
      </xsl:choose>    
    </listitem>
  </xsl:template>
  <xsl:template match="html:b|html:strong">
    <emphasis role="bold">
      <xsl:apply-templates/>
    </emphasis>
  </xsl:template>
  <xsl:template match="html:i|html:em">
    <emphasis>
      <xsl:apply-templates/>
    </emphasis>
  </xsl:template>
  <xsl:template match="html:tt">
    <literal>
      <xsl:apply-templates/>
    </literal>
  </xsl:template>
  <xsl:template match="html:sub">
    <subscript>
      <xsl:apply-templates select="text()"/>
    </subscript>
  </xsl:template>
  <xsl:template match="html:sup">
    <superscript>
      <xsl:apply-templates select="text()"/>
    </superscript>
  </xsl:template>
  <xsl:template match="html:blockquote">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>
  <xsl:template match="html:span[contains(@style,'text-decoration: underline')]|html:u">
    <emphasis role="underline">
      <xsl:apply-templates/>
    </emphasis>
  </xsl:template>
  <!-- ==================== -->
  <!-- = Ignored Elements = -->
  <!-- ==================== -->
  <xsl:template match="html:a"/>
  <xsl:template match="html:hr"/>
  <xsl:template match="html:br">
    <xsl:processing-instruction name="linebreak" />
  </xsl:template>
  <xsl:template match="html:li[normalize-space(.) = '' and count(*) = 0]"/>
  <xsl:template match="html:p[normalize-space(.) = '' and count(*) = 0]"/>
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="normalize-space(.) = ''"/>
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ==================== -->
  <!-- = Table Conversion = -->
  <!-- ==================== -->
  <xsl:template match="html:table">
    <xsl:variable name="column_count">
      <xsl:call-template name="count_columns">
        <xsl:with-param name="table" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <informaltable>
      <tgroup>
        <xsl:attribute name="cols">
          <xsl:value-of select="$column_count"/>
        </xsl:attribute>
        <xsl:call-template name="generate-colspecs">
          <xsl:with-param name="count" select="$column_count"/>
        </xsl:call-template>
        <thead>
          <xsl:apply-templates select="html:tr[1]"/>
        </thead>
        <tbody>
          <xsl:apply-templates select="html:tr[position() != 1]"/>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>
  <xsl:template name="generate-colspecs">
    <xsl:param name="count" select="0"/>
    <xsl:param name="number" select="1"/>
    <xsl:choose>
      <xsl:when test="$count &lt; $number"/>
      <xsl:otherwise>
        <colspec>
          <xsl:attribute name="colnum">
            <xsl:value-of select="$number"/>
          </xsl:attribute>
          <xsl:attribute name="colname">
            <xsl:value-of select="concat('col',$number)"/>
          </xsl:attribute>
        </colspec>
        <xsl:call-template name="generate-colspecs">
          <xsl:with-param name="count" select="$count"/>
          <xsl:with-param name="number" select="$number + 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="html:tr">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>
  <xsl:template match="html:th|html:td">
    <xsl:variable name="position" select="count(preceding-sibling::*) + 1"/>
    <entry>
      <xsl:if test="@colspan &gt; 1">
        <xsl:attribute name="namest">
          <xsl:value-of select="concat('col',$position)"/>
        </xsl:attribute>
        <xsl:attribute name="nameend">
          <xsl:value-of select="concat('col',$position + number(@colspan) - 1)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@rowspan &gt; 1">
        <xsl:attribute name="morerows">
          <xsl:value-of select="number(@rowspan) - 1"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </entry>
  </xsl:template>
  <xsl:template match="html:td_null">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="enclose_with_paras">
    <xsl:param name="nodeset" />
    <xsl:for-each select="$nodeset/node()">
      <xsl:choose>
        <xsl:when test="self::text() or name(.)!='p'">            
          <para>
            <xsl:apply-templates select="." />
          </para>                        
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="count_columns">
    <xsl:param name="table" select="."/>
    <xsl:param name="row" select="$table/html:tr[1]"/>
    <xsl:param name="max" select="0"/>
    <xsl:choose>
      <xsl:when test="local-name($table) != 'table'">
        <xsl:message>Attempting to count columns on a non-table element</xsl:message>
      </xsl:when>
      <xsl:when test="local-name($row) != 'tr'">
        <xsl:message>Row parameter is not a valid row</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <!-- Count cells in the current row -->
        <xsl:variable name="current_count">
          <xsl:call-template name="count_cells">
            <xsl:with-param name="cell" select="$row/html:td[1]|$row/html:th[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <!-- Check for the maximum value of $current_count and $max -->
        <xsl:variable name="new_max">
          <xsl:choose>
            <xsl:when test="$current_count &gt; $max">
              <xsl:value-of select="number($current_count)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="number($max)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- If this is the last row, return $max, otherwise continue -->
        <xsl:choose>
          <xsl:when test="count($row/following-sibling::html:tr) = 0">
            <xsl:value-of select="$new_max"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="count_columns">
              <xsl:with-param name="table" select="$table"/>
              <xsl:with-param name="row" select="$row/following-sibling::html:tr"/>
              <xsl:with-param name="max" select="$new_max"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="count_cells">
    <xsl:param name="cell"/>
    <xsl:param name="count" select="0"/>
    <xsl:variable name="new_count">
      <xsl:choose>
        <xsl:when test="$cell/@colspan &gt; 1">
          <xsl:value-of select="number($cell/@colspan) + number($count)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number('1') + number($count)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="count($cell/following-sibling::*) &gt; 0">
        <xsl:call-template name="count_cells">
          <xsl:with-param name="cell" select="$cell/following-sibling::*[1]"/>
          <xsl:with-param name="count" select="$new_count"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$new_count"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ============== -->
  <!-- = Catch-alls = -->
  <!-- ============== -->
  <xsl:template match="*">
    <xsl:message>No template for <xsl:value-of select="name()"/></xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:message>No template for <xsl:value-of select="name()"/></xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
