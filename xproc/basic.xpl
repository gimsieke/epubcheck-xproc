<?xml version="1.0" encoding="utf-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:css="http://www.w3.org/1996/css"
	xmlns:epub="http://www.idpf.org/2007/ops"
  type="epub:basic"
  name="basic"
  version="1.0">

  <p:output port="opfout">
    <p:pipe step="opf" port="result" />
  </p:output>
  <p:output port="opfdir">
    <p:pipe step="opf" port="opfdir" />
  </p:output>
  <p:output port="reports" sequence="true">
    <p:pipe step="reports" port="result" />
  </p:output>
  <p:output port="html-report-fragments" sequence="true">
    <p:pipe step="html-report-fragments" port="result" />
  </p:output>
  
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

  <epub:validate-spinecontent name="validate-spinecontent">
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
    <p:output port="result" sequence="true" />
    <p:iteration-source>
      <p:pipe step="validate-opf" port="report" />
      <p:pipe step="validate-ncx" port="report" />
      <p:pipe step="validate-spinecontent" port="report" />
    </p:iteration-source>
    <p:identity>
      <p:input port="source">
        <p:pipe step="reports" port="current" />
      </p:input>
    </p:identity>
  </p:for-each>

  <epub:render-plain-reports name="html-report-fragments"/>

</p:pipeline>
