<?xml version="1.0"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cx="http://xmlcalabash.com/ns/extensions" 
	xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:opf="http://www.idpf.org/2007/opf"
  version="1.0">

  <p:declare-step type="cx:zipdir">
    <p:option name="zipfile" />
    <p:output port="result"/>

    <cx:unzip>
      <p:with-option name="href" select="$zipfile" />
    </cx:unzip>
  </p:declare-step>

  <p:declare-step type="epub:opf" name="opf">
    <p:option name="epubfile" />
    <p:output port="result" primary="true"/>
    <p:output port="opfdir">
      <p:pipe step="opfdir" port="result" />
    </p:output>

    <cx:unzip name="container">
      <p:with-option name="href" select="$epubfile" />
      <p:with-option name="file" select="'META-INF/container.xml'" />
    </cx:unzip>

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

    <cx:message>
      <p:with-option name="message" select="concat('OPFDIR: ', //opfdir)"/>
    </cx:message>

    <cx:unzip>
      <p:with-option name="href" select="$epubfile" />
      <p:with-option name="file" select="/*:container/*:rootfiles/*:rootfile/@full-path">
        <p:pipe step="container" port="result" />
      </p:with-option>
    </cx:unzip>
  </p:declare-step>


  <p:declare-step type="epub:spinecontent" name="spinecontent">
    <p:input port="opf" primary="true" />
    <p:option name="epubfile" />
    <p:option name="opfdir" />
    <p:output port="result"/>

    <p:for-each>
      <p:iteration-source select="//opf:spine/*" />
      <p:variable name="id" select="/*/@idref"/>
      <p:variable name="filename" select="//opf:manifest/opf:item[@id eq $id]/@href">
        <p:pipe step="spinecontent" port="opf" />
      </p:variable>

      <cx:message>
        <p:with-option name="message" select="concat('ID: ', $id)"/>
      </cx:message>
      <cx:message>
        <p:with-option name="message" select="concat('FN: ', concat($opfdir, $filename))"/>
      </cx:message>

      <cx:unzip>
        <p:with-option name="href" select="$epubfile" />
        <p:with-option name="file" select="concat($opfdir, $filename)" />
<!--       <p:with-option name="file" select="'META-INF/container.xml'" /> -->
      </cx:unzip>

    </p:for-each>
  
    <p:wrap-sequence wrapper="spinecontent" wrapper-namespace="http://www.idpf.org/2007/ops" />

  </p:declare-step>

</p:library>

