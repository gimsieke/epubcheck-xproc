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

  <p:import href="../lib/xproc-extensions.xpl" />
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



  <p:declare-step type="epub:source-or-href-doc" name="doc">
    <p:option name="href" />
    <p:input port="source" primary="true" />
    <p:output port="result"  primary="true"/>

    <p:choose>
      <p:xpath-context>
        <p:pipe step="doc" port="source"/>
      </p:xpath-context>
      <p:when test="$href">
        <p:load>
          <p:with-option name="href" select="$href" />
        </p:load>
      </p:when>
      <p:otherwise>
        <p:identity />
      </p:otherwise>
    </p:choose>
  </p:declare-step>


  <p:declare-step type="epub:validate-part" name="validate-part">
    <p:option name="href" select="''" />
    <p:option name="epub-version" />
    <p:option name="content-type" />
    <p:output port="result" primary="true"/>
    <p:input port="source" primary="true"/>  

    <p:variable name="validation-type" select="//validation[@target eq $content-type][@epubversion eq $epub-version]/@type">
      <p:document href="../conf/versionmap.xml" />
    </p:variable>
    
    <p:variable name="schema-file" select="//validation[@target eq $content-type][@epubversion eq $epub-version]/@href">
      <p:document href="../conf/versionmap.xml" />
    </p:variable>

    <epub:source-or-href-doc name="doc">
      <p:with-option name="href" select="if ($href ne '') then $href else ()" />
    </epub:source-or-href-doc>

    <!--
    <cx:message>
      <p:with-option name="message" select="concat('vt: ', $epub-version)" />
    </cx:message>
    -->

    <p:load name="schema">
      <p:with-option name="href" select="$schema-file" />
    </p:load>

    <p:choose>
      <p:when test="$validation-type eq 'rng'">
        <p:validate-with-relax-ng>
          <p:input port="source">
             <p:pipe step="doc" port="result"/>
          </p:input>
          <p:input port="schema">
            <p:pipe step="schema" port="result"/>
          </p:input>
        </p:validate-with-relax-ng>
      </p:when>
      <p:when test="$validation-type eq 'nvdl'">
        <cx:nvdl>
          <p:input port="source">
            <p:pipe step="doc" port="result"/>
          </p:input>
          <p:input port="nvdl">
            <p:pipe step="schema" port="result"/>
          </p:input>
          <p:input port="schemas">
            <p:empty/>
          </p:input>
        </cx:nvdl>
      </p:when>
    </p:choose>

  </p:declare-step>


  <p:declare-step type="epub:validate-ncx" name="validate-ncx">
    <p:option name="epubdir" />
    <p:option name="opfdir" />
    <p:input port="ocx" primary="true" />
    <p:output port="result" primary="true" />

    <epub:validate-part>
      <p:with-option name="href" select="concat($epubdir, '/', $opfdir, //opf:manifest/opf:item[@id eq 'ncx']/@href)" />
      <p:with-option name="epub-version" select="/*/@version" />
      <p:with-option name="content-type" select="'ncx'" />
    </epub:validate-part>
  </p:declare-step>

  <p:declare-step type="epub:validate-opf" name="validate-opf">
    <p:input port="ocx" primary="true" />
    <p:output port="result" primary="true" />

    <epub:validate-part>
      <p:with-option name="epub-version" select="/*/@version" />
      <p:with-option name="content-type" select="'opf'" />
    </epub:validate-part>
  </p:declare-step>


  <p:declare-step type="epub:validate-spinecontent" name="validate-spinecontent">
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
        <p:pipe step="validate-spinecontent" port="opf" />
      </p:variable>

      <p:load name="file">
        <p:with-option name="href" select="concat($epubdir, '/', $opfdir, $filename)" />
      </p:load>
      
      <epub:validate-part>
        <p:with-option name="epub-version" select="/*/@version">
          <p:pipe step="validate-spinecontent" port="opf"/>
        </p:with-option>
        <p:with-option name="content-type" select="'spine-html'" />
      </epub:validate-part>

      <p:add-attribute match="/*" attribute-name="opf-path">
        <p:with-option name="attribute-value" select="concat($opfdir, $filename)" />
      </p:add-attribute>

    </p:for-each>
  
    <p:wrap-sequence wrapper="spinecontent" wrapper-namespace="http://www.idpf.org/2007/ops" name="wrap-spineconents"/>

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

