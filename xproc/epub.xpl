<?xml version="1.0"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cx="http://xmlcalabash.com/ns/extensions" 
  xmlns:css="http://www.w3.org/1996/css"
	xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:c="http://www.w3.org/ns/xproc-step"  
  version="1.0">

  <p:import href="css.xpl" />

  <p:declare-step type="epub:opf" name="opf">
    <p:option name="epubdir" />
    <p:output port="result" primary="true"/>
    <p:output port="opfdir">
      <p:pipe step="opfdir" port="result" />
    </p:output>

    <p:load name="container">
      <p:with-option name="href" select="concat($epubdir, '/META-INF/container.xml')" />
    </p:load>

    <!-- This is just ridiculous. XProc, thou art not perfect. -->
    <p:string-replace match="/opfdir/text()" name="opfdir">
      <p:input port="source">
        <p:inline>
          <opfdir>opfdir</opfdir>
        </p:inline>
      </p:input>
      <p:with-option name="replace" select="concat('''', replace(/*:container/*:rootfiles/*:rootfile/@full-path, '[^/]+$', ''), '''')">
        <p:pipe step="container" port="result" />
      </p:with-option>
    </p:string-replace>

    <p:load>
      <p:with-option name="href" select="concat($epubdir, '/', /*:container/*:rootfiles/*:rootfile/@full-path)">
        <p:pipe step="container" port="result" />
      </p:with-option>
    </p:load>
  </p:declare-step>


  <p:declare-step type="epub:css-expanded-spinecontent" name="css-expanded-spinecontent">
    <p:input port="opf" primary="true" />
    <p:option name="epubdir" />
    <p:option name="opfdir" />

    <p:output port="result" primary="true">
      <p:pipe step="wrap-spineconents" port="result" />
    </p:output>

    <p:for-each>
      <p:iteration-source select="//opf:spine/*" />
      <p:variable name="id" select="/*/@idref"/>
      <p:variable name="filename" select="//opf:manifest/opf:item[@id eq $id]/@href">
        <p:pipe step="css-expanded-spinecontent" port="opf" />
      </p:variable>

      <p:load name="file">
        <p:with-option name="href" select="concat($epubdir, '/', $opfdir, $filename)" />
      </p:load>
      
      <css:expand/>

      <p:add-attribute match="/*" attribute-name="opf-path">
        <p:with-option name="attribute-value" select="concat($opfdir, $filename)" />
      </p:add-attribute>

    </p:for-each>
  
    <p:wrap-sequence wrapper="spinecontent" wrapper-namespace="http://www.idpf.org/2007/ops" name="wrap-spineconents"/>

  </p:declare-step>
    

</p:library>

