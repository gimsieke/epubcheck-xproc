<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:s="http://purl.oclc.org/dsdl/schematron"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:c="http://www.w3.org/ns/xproc-step"  
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0"
  >

  <xsl:output method="xml" indent="yes" />

  <xsl:param name="schematron-content-links" as="xs:string" />

  <xsl:template name="main">
    <div class="plain-reports">
      <xsl:apply-templates select="collection()/*" />
    </div>
  </xsl:template>

  <xsl:template match="c:error">
    <div>
      <p>
        <span class="err-block">ERROR</span>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="fileatts" />
      </p>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="c:report[. eq 'ok']">
    <div>
      <p>
        <span class="ok-block">OK</span>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="fileatts" />
      </p>
    </div>
  </xsl:template>

  <xsl:template match="c:report">
    <div>
      <span class="wrn-block">REPORT</span>
      <xsl:apply-templates select="." mode="fileatts" />
      <xsl:apply-templates />
    </div>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*" mode="fileatts">
    <b><xsl:value-of select="@part" /></b> file <xsl:value-of select="@href" />
  </xsl:template>

  <xsl:template match="reports">
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>