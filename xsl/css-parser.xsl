<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xslout="bogo"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:letex="http://www.le-tex.de/namespace"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:css="http://www.w3.org/1996/css"
  exclude-result-prefixes="xs">
  
  <!-- CSS parser by Grit Rolewski, le-tex publishing services GmbH.
       Integrated into epubcheck-xproc by Gerrit Imsieke.
       See ../README for copyright information
    -->

  <xsl:import href="css-util.xsl"/>

  <xsl:output indent="yes" />

  <xsl:variable name="base-uri" select="base-uri(/)" as="xs:string" />

  <xsl:template match="/">
    <css xmlns="http://www.w3.org/1996/css">
      <xsl:apply-templates select="html:html/html:head/(html:link[@rel eq 'stylesheet'] union html:style)" mode="extract-css" />
    </css>
  </xsl:template>

  <xsl:template match="html:link" mode="extract-css">
    <!-- §§§ source of error: linked stylesheet may have any (undeclared or declared) encoding, 
         but you won’t find it out until you see the @charset rule or until reading fails.
         As a workaround, we could first try ASCII, then ISO-8859-1, then UTF-8 -->
    <xsl:sequence select="letex:extract-css(unparsed-text(resolve-uri(@href, $base-uri)), resolve-uri(@href, $base-uri))" />
  </xsl:template>

  <xsl:template match="html:style" mode="extract-css">
    <xsl:sequence select="letex:extract-css(string-join(for $n in node() return $n, ''), 'intenal')" />
  </xsl:template>

  <xsl:function name="letex:extract-css" as="element(*)*">
    <xsl:param name="raw-css" as="xs:string" />
    <xsl:param name="origin" as="xs:string" />
    <xsl:analyze-string select="$raw-css" regex="/\*.*?\*/">
      <!-- ignore comments in css -->
      <xsl:matching-substring/>
      <xsl:non-matching-substring>
        <!-- separate rule-sets -->
        <xsl:for-each select="tokenize(normalize-space(.), '\}')[matches(., '\S')]">
          <xsl:if test="not(matches(., '^\s?@'))">
            <xsl:element name="ruleset"  xmlns="http://www.w3.org/1996/css">
              <xsl:if test="$origin!=''">
                <xsl:attribute name="origin" select="$origin" />
              </xsl:if>
              <xsl:element name="raw-css">
                <xsl:value-of select="normalize-space(.), '}'" />
              </xsl:element>
              <!-- separate selectors from declarations -->
              <xsl:variable name="tmp" select="normalize-space(substring-before(., '{'))" />
              <xsl:call-template name="selectors">
                <xsl:with-param name="raw-selectors" select="normalize-space(substring-before(., '{'))" />
              </xsl:call-template>
              <xsl:call-template name="declarations">
                <xsl:with-param name="raw-declarations" select="normalize-space(substring-after(., '{'))" />
              </xsl:call-template>
            </xsl:element>
          </xsl:if>
          <xsl:if test="matches(normalize-space(.), '^@')">
            <xsl:call-template name="at-rules">
              <xsl:with-param name="at-rule" select="normalize-space(.)" />
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:template name="selectors">
    <xsl:param name="raw-selectors" />
    <xsl:for-each select="tokenize($raw-selectors, ',\s*')">
      <xsl:element name="selector" xmlns="http://www.w3.org/1996/css">
        <xsl:attribute name="raw-selector" select="." />
        <xsl:if test="matches(., ':(first-child|link|visited|hover|active|focus|lang|first-line|first-letter|before|after)')">
          <xsl:variable name="pseudo" as="node()*">
            <xsl:analyze-string select="." regex=":(first-child|link|visited|hover|active|focus|lang|first-line|first-letter|before|after)">
              <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)" />
              </xsl:matching-substring>
              <xsl:non-matching-substring/>
            </xsl:analyze-string>
          </xsl:variable>
          <xsl:attribute name="pseudo">
            <xsl:for-each select="$pseudo">
              <xsl:value-of select="concat(if (position() gt 1) then ' ' else '', .)" />
            </xsl:for-each>
          </xsl:attribute>
        </xsl:if>
        <!-- transform selector to xpath -->
        <xsl:variable name="selector-as-xpath" select="letex:selector2xpath(.)" />
        <!-- <xsl:attribute name="priority" select="letex:getPriority($selector-as-xpath)" /> -->
        <xsl:attribute name="priority" select="letex:getPriority(.)" />
        <xsl:value-of select="$selector-as-xpath" />
      </xsl:element>
    </xsl:for-each>
  </xsl:template>



  <xsl:function name="letex:selector2xpath">
    <xsl:param name="raw-selector" />
    <xsl:variable name="resolve-attributes">
      <xsl:value-of select="letex:resolve-attributes($raw-selector)"/>
    </xsl:variable>
    <xsl:variable name="resolve-combinators">
      <xsl:value-of select="letex:resolve-combinators($resolve-attributes)" />
    </xsl:variable>
    <xsl:variable name="resolve-pseudo-classes">
      <xsl:value-of select="letex:resolve-pseudo-classes($resolve-combinators)"/>
    </xsl:variable>
    <xsl:variable name="resolve-classes">
      <xsl:value-of select="letex:resolve-classes($resolve-pseudo-classes)"/>
    </xsl:variable>
    <xsl:variable name="resolve-ids">
      <xsl:value-of select="letex:resolve-ids($resolve-classes)"/>
    </xsl:variable>
    <xsl:for-each select="$resolve-ids">
      <xsl:analyze-string select="." regex="(^|[/])(\[)">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)" />
          <xsl:text>*</xsl:text>
          <xsl:value-of select="regex-group(2)" />
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="." />
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:for-each>
  </xsl:function>

  <xsl:function name="letex:resolve-combinators">
    <xsl:param name="var-resolve-combinators" />
    <xsl:variable name="combinators" select="'[+> ]'" />
    <xsl:variable name="not-combinators" select="'[^+> ]*'" />
    <xsl:choose>
      <xsl:when test="matches($var-resolve-combinators, $combinators)">
        <xsl:analyze-string select="$var-resolve-combinators" regex="({$not-combinators})\s*({$combinators})\s*({$not-combinators})">
          <xsl:matching-substring>
            <xsl:choose>
              <xsl:when test="matches(regex-group(2), '^\s$')">
                <xsl:value-of select="letex:selector2xpath(regex-group(1))" />
                <xsl:text>//</xsl:text>
                <xsl:value-of select="letex:selector2xpath(regex-group(3))" />
              </xsl:when>
              <xsl:when test="regex-group(2) = '>'">
                <xsl:value-of select="letex:selector2xpath(regex-group(1))" />
                <xsl:text>/</xsl:text>
                <xsl:value-of select="letex:selector2xpath(regex-group(3))" />
              </xsl:when>
              <xsl:when test="regex-group(2) = '+'">
                <xsl:value-of select="letex:selector2xpath(regex-group(3))" />
                <xsl:text>[preceding-sibling::*[1]/self::</xsl:text>
                <xsl:value-of select="letex:selector2xpath(regex-group(1))" />
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message>ERROR: Unknown combinator "<xs:value-of select="regex-group(3)" />" found in selector "<xsl:value-of select="$var-resolve-combinators" />".</xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="." />
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$var-resolve-combinators" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="letex:resolve-pseudo-classes"><!-- processes pseudo-elements, too -->
    <xsl:param name="var-resolve-pseudo-classes" />
    <xsl:choose>
      <xsl:when test="matches($var-resolve-pseudo-classes, ':(first-child|link|visited|hover|active|focus|lang|first-line|first-letter|before|after)')">
        <xsl:analyze-string select="$var-resolve-pseudo-classes" regex="(^|[^:]*):([^:.]*)">
          <xsl:matching-substring>
            <xsl:choose>
              <xsl:when test="regex-group(2) = 'first-child'">
                <xsl:value-of select="letex:resolve-pseudo-classes(regex-group(1))" />
                <xsl:text>[not(preceding-sibling::*)]</xsl:text>
              </xsl:when>
              <xsl:when test="regex-group(2) = ('link', 'visited')">
                <xsl:value-of select="letex:resolve-pseudo-classes(regex-group(1))" />
                <xsl:text>[exists(@href)]</xsl:text>
              </xsl:when>
              <xsl:when test="regex-group(2) = ('hover', 'active', 'focus', 'first-line', 'first-letter', 'before', 'after')">
                <xsl:value-of select="letex:resolve-pseudo-classes(regex-group(1))" />
              </xsl:when>
              <xsl:when test="matches(regex-group(2), '^lang')">
                <xsl:value-of select="letex:resolve-pseudo-classes(regex-group(1))" />
                <xsl:text>[matches(ancestor-or-self::*/@lang,'</xsl:text>
                <xsl:value-of select="substring-before(substring-after(., '('), ')')" />
                <xsl:text>')]</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="." />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="." />
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$var-resolve-pseudo-classes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="letex:resolve-classes">
    <xsl:param name="var-resolve-classes" />
    <xsl:analyze-string select="$var-resolve-classes" regex="^([^=']*)\.([^\.:/\[]+)">
      <xsl:matching-substring>
        <xsl:value-of select="letex:resolve-classes(regex-group(1))" />
        <xsl:text>[matches(@class,'(^|\s)</xsl:text>
        <xsl:value-of select="regex-group(2)" />
        <xsl:text>(\s|$)')]</xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="." />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="letex:resolve-ids">
    <xsl:param name="var-resolve-ids" />
    <xsl:analyze-string select="$var-resolve-ids" regex="#([^\.:/\[]+)">
      <xsl:matching-substring>
        <xsl:text>[@id='</xsl:text>
        <xsl:value-of select="regex-group(1)" />
        <xsl:text>']</xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="." />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="letex:resolve-attributes">
    <xsl:param name="var-resolve-attributes" />
    <xsl:variable name="quots">"</xsl:variable>
    <xsl:analyze-string select="$var-resolve-attributes" regex="\[(([^|~=@]*)?(=|~=|\|=)?{$quots}?([^\[@]*?){$quots}?)\]">
      <xsl:matching-substring>
        <xsl:text>[</xsl:text>
        <xsl:choose>
          <xsl:when test="regex-group(3) = ''">
            <xsl:text>exists(@</xsl:text>
            <xsl:value-of select="regex-group(1)" />
            <xsl:text>)</xsl:text>
          </xsl:when>
          <xsl:when test="regex-group(3) = '='">
            <xsl:text>@</xsl:text>
            <xsl:value-of select="regex-group(2)" />
            <xsl:text>='</xsl:text>
            <xsl:value-of select="regex-group(4)" />
            <xsl:text>'</xsl:text>
          </xsl:when>
          <xsl:when test="regex-group(3) = '~='">
            <xsl:text>matches(@</xsl:text>
            <xsl:value-of select="regex-group(2)" />
            <xsl:text>,'(^|\s)</xsl:text>
            <xsl:value-of select="regex-group(4)" />
            <xsl:text>(\s|$)')</xsl:text>
          </xsl:when>
          <xsl:when test="regex-group(3) = '|='">
            <xsl:text>matches(@</xsl:text>
            <xsl:value-of select="regex-group(2)" />
            <xsl:text>,'^</xsl:text>
            <xsl:value-of select="regex-group(4)" />
            <xsl:text>&#x2d;?$')</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="." />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="." />
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  
  <xsl:function name="letex:getPriority">
    <xsl:param name="selector" />
    <!--a, @style-->
    <xsl:value-of select="'0'" />
    <xsl:text>,</xsl:text>
    <!--b, count id attributes-->
    <xsl:value-of select="letex:getCounts($selector, '#')[1]" />
    <xsl:text>,</xsl:text>
    <!--c, count attributes and pseudo-classes-->
    <xsl:value-of select="letex:getCounts($selector, '(\[(([^|~=@]*)?(=|~=|\|=)?[^\[@]*?)\]|\.)')[1] + letex:getCounts($selector, ':(first-child|link|visited|hover|active|focus|lang)')[1]" />
    <xsl:text>,</xsl:text>
    <!--d, count elements and pseudo-elements-->
    <xsl:value-of select="letex:getCounts($selector, '[+> ]')[2] + letex:getCounts($selector, ':(first-line|first-letter|before|after)')[1]" />
  </xsl:function>

  <xsl:function name="letex:getCounts">
    <xsl:param name="selector" />
    <xsl:param name="regex" />
    <xsl:variable name="find-number">
      <xsl:analyze-string select="$selector" regex="\s*({$regex})\s*">
        <xsl:matching-substring>
          <counter />
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:if test="matches(., '^[^.*]')">
            <restcounter />
          </xsl:if>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:value-of select="count($find-number/counter)" />
    <xsl:value-of select="count($find-number/restcounter)" />
  </xsl:function>


  <!-- at rules -->

  <xsl:template name="at-rules">
    <xsl:param name="at-rule" />
    <xsl:for-each select="tokenize($at-rule, '@')[matches(., '\S+')]">
      <xsl:variable name="type">
        <xsl:value-of select="substring-before(normalize-space(.), ' ')" />
      </xsl:variable>
      <xsl:element name="atrule" xmlns="http://www.w3.org/1996/css">
        <xsl:attribute name="type" select="$type" />
        <xsl:value-of select="concat('@', .)" />
      </xsl:element>
      <xsl:if test="$type='import'">
        <xsl:variable name="import-css">
          <xsl:analyze-string select="." regex="import\s*(url\()?&#34;(.*)&#34;\)?\s*([^;]+)?.*$">
            <xsl:matching-substring>
              <xsl:element name="css"><xsl:value-of select="regex-group(2)" /></xsl:element>
              <xsl:element name="media"><xsl:value-of select="regex-group(3)" /></xsl:element>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:variable>
        <xsl:sequence select="letex:extract-css(unparsed-text(resolve-uri($import-css/css, $base-uri)), $import-css/css)" />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- mode add-position -->
  
  <xsl:template match="*" mode="add-position">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*" mode="add-position">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="selector" mode="add-position">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current" />
      <xsl:attribute name="position" select="count(parent::ruleset/preceding-sibling::ruleset)+1" />
      <xsl:apply-templates select="node()" mode="#current" />
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>