<?xml version="1.0" encoding="utf-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:epub="http://www.idpf.org/2007/ops"
  version="1.0">

  <p:option name="epubfile" />

  <p:import href="../lib/xproc-extensions.xpl" />
  <p:import href="unzip.xpl" />

  <epub:opf name="opf">
    <p:with-option name="epubfile" select="$epubfile" />
  </epub:opf>

  <p:sink/>

  <epub:spinecontent name="spinecontent">
    <p:with-option name="epubfile" select="$epubfile" />
    <p:with-option name="opfdir" select="//opfdir">
      <p:pipe step="opf" port="opfdir" />
    </p:with-option>
    <p:input port="opf">
      <p:pipe step="opf" port="result" />
    </p:input>
  </epub:spinecontent>

</p:pipeline>
