<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xslout="bogo"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:s="http://purl.oclc.org/dsdl/schematron"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0"
  >

  <xsl:output method="xml" indent="yes"  />

  <xsl:namespace-alias stylesheet-prefix="xslout" result-prefix="xsl"/>

  <xsl:template match="/">
    <xslout:stylesheet
      version="2.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema" 
      xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
      xmlns:css="http://www.w3.org/1996/css"
      xmlns:s="http://purl.oclc.org/dsdl/schematron"
      xmlns:html="http://www.w3.org/1999/xhtml"
      exclude-result-prefixes="svrl s xs html"
      >

      <xslout:output method="xhtml" cdata-section-elements="script html:script" />


      <xslout:template match="/">
        <div class="content-schematron">
          <xsl:call-template name="report-nav" />
          <xslout:apply-templates select="//html:html" />
        </div>
      </xslout:template>

      <xslout:template match="html:html" mode="#default">
        <h3 class="non-content-heading">
          <xslout:value-of select="@opf-path"/>
        </h3>
        <xslout:apply-templates select="html:body/node()" mode="#current" />
      </xslout:template>

      <xslout:template match="*" mode="#default">
        <xslout:copy>
          <xslout:apply-templates select="@*" mode="#current" />
          <xslout:attribute name="style"><xslout:apply-templates select="@css:*" mode="css" /></xslout:attribute>
          <xslout:apply-templates select="node()" mode="#current" />
        </xslout:copy>
      </xslout:template>

      <xslout:template match="@*" mode="#default">
        <xslout:copy-of select="." />
      </xslout:template>

      <xslout:template match="@css:*" mode="#default" />

      <xslout:template match="@css:position[. = ('fixed', 'absolute')]" mode="css" /><!-- plain display of position:fixed -->
      <xslout:template match="@*" mode="css"><xslout:value-of select="local-name(.)" />: <xslout:value-of select="." />; </xslout:template>


      <xsl:apply-templates select="//svrl:successful-report union //svrl:failed-assert" mode="create-patch-rules" />
    </xslout:stylesheet>
  </xsl:template>

  <xsl:template match="svrl:text" mode="create-patch-rules">
    <xslout:template match="{../@location}//text()[index-of({../@location}//text(), .) eq 1]">
      <xsl:attribute name="priority" select="index-of(for $n in //*[@location eq current()/../@location] return generate-id($n), generate-id(..))" />
      <span>
        <xsl:attribute name="class" select="concat('hl ', s:span[@class eq 'msgid'], ' ', if (s:span[@class eq 'severity'] = 'ERR') then 'err' else 'wrn')" />
        <xsl:attribute name="title" >
          <xsl:value-of select="s:span[@class eq 'msgid']" />
          <xsl:apply-templates mode="#current" />
        </xsl:attribute>
        <xslout:next-match/>
      </span>
    </xslout:template>
  </xsl:template>

  <xsl:template match="s:span[@class = ('severity', 'msgid')]" mode="create-patch-rules summary" priority="2" />
  <xsl:template match="s:span[@class]" mode="create-patch-rules">
    <span>
      <xsl:copy-of select="@class" />
      <xsl:apply-templates mode="#current" />
    </span>
  </xsl:template>

  <xsl:template match="s:span[@class = 'info']" mode="summary">
    <xsl:text>&#x2026;</xsl:text>
  </xsl:template>

  <xsl:template name="report-nav">
    <h2 class="non-content-heading">Content analysis report</h2>
    <p><xsl:value-of select="count(//svrl:text/s:span[@class eq 'severity'][. eq 'WRN'])" /> warnings</p>
    <p><xsl:value-of select="count(//svrl:text/s:span[@class eq 'severity'][. eq 'ERR'])" /> errors</p>
    <xsl:for-each-group select="//svrl:text" group-by="s:span[@class eq 'msgid']">
      <p class="schematron-report">
        <span class="hl {current-grouping-key()} {lower-case(s:span[@class eq 'severity'])}">
          <button>
            <xsl:attribute name="onclick" select="concat('makeTransparent(''', s:span[@class eq 'msgid'], ''')')" />
            <xsl:value-of select="s:span[@class eq 'severity']" />
          </button>
        </span>
        <xsl:text> </xsl:text>
        <xsl:apply-templates mode="summary"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="count(current-group())" />
        <xsl:text>)</xsl:text>
      </p>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="*" mode="create-patch-rules">
    <xsl:apply-templates mode="#current" />
  </xsl:template>

</xsl:stylesheet>