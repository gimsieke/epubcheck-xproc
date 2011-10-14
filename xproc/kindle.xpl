<?xml version="1.0" encoding="utf-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:css="http://www.w3.org/1996/css"
  xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:c="http://www.w3.org/ns/xproc-step"  
  version="1.0">

  <p:option name="epubdir" />
  <p:option name="lang" select="'en'"/>

  <p:import href="epub.xpl" />
  <p:import href="basic.xpl" />

  <p:serialization port="result" omit-xml-declaration="false" />

  <epub:load-if-exists name="l10n">
    <p:with-option name="href" select="concat('../l10n/kindle_', $lang, '.xml')" />
  </epub:load-if-exists>

  <epub:basic name="basic">
    <p:with-option name="epubdir" select="$epubdir" />
  </epub:basic>

  <p:sink/>

  <epub:css-expanded-spinecontent>
    <p:with-option name="epubdir" select="$epubdir" />
    <p:with-option name="opfdir" select="//opfdir">
      <p:pipe step="basic" port="opfdir"/>
    </p:with-option>
    <p:input port="opf">
      <p:pipe step="basic" port="opfout" />
    </p:input>
  </epub:css-expanded-spinecontent>

  <epub:schematron-spinehtml name="schematron-spinehtml">
    <p:with-option name="schematron" select="'../sch/kindle.sch'" />
    <p:input port="l10n">
      <p:pipe step="l10n" port="result" />
    </p:input>
  </epub:schematron-spinehtml>

  <p:sink/>

  <epub:htmlreport name="htmlreport">
    <p:input port="source">
      <p:pipe step="basic" port="html-report-fragments" />
      <p:pipe step="schematron-spinehtml" port="result" />
    </p:input>
  </epub:htmlreport>

</p:pipeline>
