<?xml version="1.0"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cx="http://xmlcalabash.com/ns/extensions" 
	xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:css="http://www.w3.org/1996/css"
  xmlns:c="http://www.w3.org/ns/xproc-step"  
  version="1.0">

  <p:declare-step type="css:expand" name="expand">
    <p:input port="source" primary="true" />
    <p:output port="result" primary="true"/>

    <p:xslt>
      <p:input port="parameters"><p:empty/></p:input>
      <p:input port="stylesheet">
        <p:document href="../xsl/css-parser.xsl" />
      </p:input>
    </p:xslt>

    <p:xslt name="css-xsl">
      <p:input port="parameters"><p:empty/></p:input>
      <p:input port="stylesheet">
        <p:document href="../xsl/css2xsl.xsl" />
      </p:input>
    </p:xslt>

    <p:xslt>
      <p:input port="source">
        <p:pipe step="expand" port="source" />
      </p:input>
      <p:input port="parameters"><p:empty/></p:input>
      <p:input port="stylesheet">
        <p:pipe step="css-xsl" port="result" />
      </p:input>
    </p:xslt>

  </p:declare-step>


</p:library>

