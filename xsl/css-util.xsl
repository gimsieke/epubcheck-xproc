<xsl:stylesheet version="2.0"
    xmlns:xsl  = "http://www.w3.org/1999/XSL/Transform"
    xmlns:xs   = "http://www.w3.org/2001/XMLSchema"
    xmlns:letex  = "http://www.le-tex.de/namespace"
    xmlns:html   = "http://www.w3.org/1999/xhtml"
    xmlns:css  = "http://www.w3.org/1996/css"
    exclude-result-prefixes="xs"
>

  <!-- CSS parser by Grit Rolewski, le-tex publishing services GmbH.
       Integrated into epubcheck-xproc by Gerrit Imsieke.
       See ../README for copyright information
    -->

  <xsl:template name="declarations">
    <xsl:param name="raw-declarations" />
    <xsl:for-each select="tokenize($raw-declarations, ';\s*')[matches(., '\S')]">
      <xsl:variable name="prop" select="substring-before(., ':')" />
      <xsl:variable name="val" select="replace(normalize-space(substring-after(., ':')), '\s?!important', '')" />
      <xsl:variable name="check-shorthand-property" select="$prop=('background', 'border', 'font', 'list-style', 'margin', 'padding')" as="xs:boolean" />
      <xsl:choose>
        <xsl:when test="$check-shorthand-property">
          <xsl:sequence select="letex:handle-shorthand-properties($prop, $val)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="declaration" xmlns="http://www.w3.org/1996/css">
            <xsl:attribute name="property" select="$prop" />
            <xsl:attribute name="value" select="$val" />
            <xsl:if test="matches(substring-after(., ':'), '!important')">
              <xsl:attribute name="important" select="'yes'" />
            </xsl:if>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>


  <xsl:function name="letex:handle-shorthand-properties" as="element(*)+">
    <xsl:param name="prop" />
    <xsl:param name="val" />
    <xsl:choose>

      <xsl:when test="$prop=('margin', 'padding', 'border-style', 'border-color', 'border-width')">
        <xsl:variable name="val-seq" select="tokenize($val, ' ')" />
        <xsl:variable name="new-props">
          <props count="1">
            <top seq="1" />
            <right seq="1" />
            <bottom seq="1" />
            <left seq="1" />
          </props>
          <props count="2">
            <top seq="1" />
            <right seq="2" />
            <bottom seq="1" />
            <left seq="2" />
          </props>
          <props count="3">
            <top seq="1" />
            <right seq="2" />
            <bottom seq="3" />
            <left seq="2" />
          </props>
          <props count="4">
            <top seq="1" />
            <right seq="2" />
            <bottom seq="3" />
            <left seq="4" />
          </props>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="count($val-seq) le 4">
            <xsl:for-each select="$new-props/props[number(@count) eq count($val-seq)]/*">
              <xsl:element name="declaration" xmlns="http://www.w3.org/1996/css">
                <xsl:attribute name="property" select="concat(replace($prop, '-.*$', ''), '-', name(), substring-after($prop, 'border'))" />
                <xsl:attribute name="value" select="$val-seq[position() eq number(current()/@seq)]" />
              </xsl:element>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>ERROR! There is something wrong with property count in shorthand property "<xsl:value-of select="$prop" />": <xsl:value-of select="$val" /></xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$prop=('border')">
        <xsl:call-template name="border-vals">
          <xsl:with-param name="all-pos" select="'top right bottom left'" />
          <xsl:with-param name="val" select="$val" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="matches($prop, '^border-(left|right|top|bottom)$')">
        <xsl:call-template name="border-vals">
          <xsl:with-param name="all-pos" select="substring-after($prop, 'border-')" />
          <xsl:with-param name="val" select="$val" />
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$prop='background'">
        <xsl:variable name="new-vals">
          <vals>
            <image pos-vals="(none|url)" />
            <attachment pos-vals="(scroll|fixed)" />
            <repeat pos-vals="^(no-repeat|repeat|repeat-x|repeat-y)" />
            <color pos-vals="(transparent|\(|[a-z]+|#[0-9a-z]+)" />
            <position pos-vals="(left|right|top|bottom|center|[.0-9]+(%|em|ex|px|in|cm|mm|pt|pc))" />
          </vals>
        </xsl:variable>
        <xsl:for-each select="tokenize(replace($val, ',\s', ','), ' ')">
          <xsl:variable name="current-val">
            <xsl:choose>
              <xsl:when test="matches(., $new-vals//image/@pos-vals)">image</xsl:when>
              <xsl:when test="matches(., $new-vals//attachment/@pos-vals)">attachment</xsl:when>
              <xsl:when test="matches(., $new-vals//repeat/@pos-vals)">repeat</xsl:when>
              <xsl:when test="matches(., $new-vals//position/@pos-vals)">position</xsl:when>
              <xsl:when test="matches(., $new-vals//color/@pos-vals)">color</xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="declaration" xmlns="http://www.w3.org/1996/css">
            <xsl:attribute name="property" select="concat('background-', $current-val)" />
            <xsl:attribute name="value" select="." />
          </xsl:element>
        </xsl:for-each>
      </xsl:when>

      <xsl:when test="$prop='font'">
        <xsl:for-each select="tokenize('style variant weight size family', ' ')">
          <xsl:variable name="current-pos" select="position()" />
          <xsl:element name="declaration" xmlns="http://www.w3.org/1996/css">
            <xsl:attribute name="property" select="concat('font-', .)" />
            <xsl:attribute name="value" select="tokenize($val, ' ')[if ($current-pos le 4) then (position() eq $current-pos) else (position() ge 5)]" />
          </xsl:element>              
        </xsl:for-each>
      </xsl:when>

      <xsl:when test="$prop='list-style'">
        <xsl:variable name="new-vals">
          <vals>
            <type pos-vals="(circle|square|disc|decimal|lower-roman|upper-roman|decimal-leading-zero|lower-greek|lower-latin|upper-latin|armenian|georgian|none)" />
            <position pos-vals="(inside|outside)" />
            <image pos-vals="(none|url)" />
          </vals>
        </xsl:variable>
        <xsl:for-each select="tokenize($val, ' ')">
          <xsl:variable name="current-pos" select="position()" />
          <xsl:variable name="current-val">
            <xsl:choose>
              <xsl:when test="matches(., $new-vals//position/@pos-vals)">position</xsl:when>
              <xsl:when test="matches(., $new-vals//type/@pos-vals) and (not(. eq 'none' and (exists(tokenize($val, ' ')[position() ne $current-pos][matches(., $new-vals//type/@pos-vals)]))) or (. eq 'none' and (exists(tokenize($val, ' ')[position() gt $current-pos][. eq 'none']))))">type</xsl:when>
              <xsl:when test="matches(., $new-vals//image/@pos-vals)">image</xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="declaration" xmlns="http://www.w3.org/1996/css">
            <xsl:attribute name="property" select="concat('list-style-', $current-val)" />
            <xsl:attribute name="value" select="." />
          </xsl:element>
        </xsl:for-each>
      </xsl:when>

      <xsl:otherwise>
        <xsl:message>WARNING! Shorthand property "<xsl:value-of select="$prop" />" has not been implemented, yet!</xsl:message>
        <xsl:element name="declaration" xmlns="http://www.w3.org/1996/css">
          <xsl:attribute name="property" select="$prop" />
          <xsl:attribute name="value" select="$val" />
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>


  <xsl:template name="border-vals">
    <xsl:param name="all-pos" />
    <xsl:param name="val" />
    <xsl:variable name="new-vals">
      <vals>
        <style pos-vals="(none|dotted|dashed|solid|double|groove|ridge|inset|outset)" />
        <width pos-vals="(thin|medium|thick|^[.0-9]+)" />
        <color pos-vals="(transparent|\(|[a-z]+|#[0-9a-z]+)" />
      </vals>
    </xsl:variable>
    <xsl:for-each select="tokenize($all-pos, ' ')">
      <xsl:variable name="current-pos" select="." />
      <xsl:for-each select="tokenize(replace($val, ',\s', ','), ' ')">
        <xsl:variable name="current-val">
          <xsl:choose>
            <xsl:when test="matches(., $new-vals//style/@pos-vals)">style</xsl:when>
            <xsl:when test="matches(., $new-vals//width/@pos-vals)">width</xsl:when>
            <xsl:when test="matches(., $new-vals//color/@pos-vals)">color</xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:element name="declaration" xmlns="http://www.w3.org/1996/css">
          <xsl:attribute name="property" select="concat('border-', $current-pos, '-', $current-val)" />
          <xsl:attribute name="value" select="." />
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>