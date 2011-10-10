<?xml version="1.0" encoding="utf-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:css="http://www.w3.org/1996/css"
	xmlns:epub="http://www.idpf.org/2007/ops"
  version="1.0">

  <p:option name="epubdir" />

  <p:import href="epub.xpl" />
  <p:import href="basic.xpl" />

  <epub:basic>
    <p:with-option name="epubdir" select="$epubdir" />
  </epub:basic>

  <p:sink/>

  <epub:opf name="opf">
    <p:with-option name="epubdir" select="$epubdir" />
  </epub:opf>

  <epub:css-expanded-spinecontent>
    <p:with-option name="epubdir" select="$epubdir" />
    <p:with-option name="opfdir" select="//opfdir">
      <p:pipe step="opf" port="opfdir"/>
    </p:with-option>
  </epub:css-expanded-spinecontent>

  <epub:schematron-spinehtml>
    <p:with-option name="schematron" select="'../sch/kindle.sch'" />
  </epub:schematron-spinehtml>

</p:pipeline>
