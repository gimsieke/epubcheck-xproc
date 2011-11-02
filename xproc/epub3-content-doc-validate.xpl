<?xml version="1.0" encoding="utf-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:css="http://www.w3.org/1996/css"
  xmlns:cx="http://xmlcalabash.com/ns/extensions" 
  xmlns:c="http://www.w3.org/ns/xproc-step"  
  name="main"
  version="1.0">

  <p:import href="../lib/xproc-extensions.xpl" />

  <p:import href="epub.xpl" />

  <epub:validate-part name="validate">
    <p:with-option name="epub-version" select="'3.0'" />
    <p:with-option name="content-type" select="'spine-html'" />
  </epub:validate-part>

  <p:sink/>

  <epub:render-plain-reports>
    <p:input port="source">
      <p:pipe step="validate" port="report" />
    </p:input>
    <p:input port="l10n">
      <p:empty/>
    </p:input>
  </epub:render-plain-reports>

  <epub:htmlreport name="htmlreport" />

</p:pipeline>
