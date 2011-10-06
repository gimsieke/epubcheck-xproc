<?xml version="1.0" encoding="utf-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:css="http://www.w3.org/1996/css"
	xmlns:epub="http://www.idpf.org/2007/ops"
  type="epub:basic"
  version="1.0">

  <p:option name="epubdir" />
  
  <p:import href="epub.xpl" />

  <epub:opf name="opf">
    <p:with-option name="epubdir" select="$epubdir" />
  </epub:opf>

  <epub:validate-opf name="validate-opf"/>

  <epub:validate-ncx name="validate-ncx">
    <p:with-option name="epubdir" select="$epubdir" />
    <p:with-option name="opfdir" select="//opfdir">
      <p:pipe step="opf" port="opfdir"/>
    </p:with-option>
  </epub:validate-ncx>

  <p:sink/>

  <epub:validate-spinecontent>
    <p:with-option name="epubdir" select="$epubdir" />
    <p:with-option name="opfdir" select="//opfdir">
      <p:pipe step="opf" port="opfdir"/>
    </p:with-option>
    <p:input port="opf">
      <p:pipe step="opf" port="result"/>
    </p:input>
  </epub:validate-spinecontent>

  <p:sink/>

  <p:for-each name="reports">
    <p:iteration-source>
      <p:pipe step="validate-opf" port="report" />
      <p:pipe step="validate-ncx" port="report" />
    </p:iteration-source>
    <p:identity>
      <p:input port="source">
        <p:pipe step="reports" port="current" />
      </p:input>
    </p:identity>
  </p:for-each>

  <p:wrap-sequence wrapper="report" name="joint-report"/>

</p:pipeline>
