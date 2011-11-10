<?xml version="1.0"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:cx="http://xmlcalabash.com/ns/extensions" 
  xmlns:css="http://www.w3.org/1996/css"
	xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:opf="http://www.idpf.org/2007/opf"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:c="http://www.w3.org/ns/xproc-step"  
	xmlns:epubcheck="http://www.le-tex.de/epubcheck"
  version="1.0">

  <p:import href="../lib/xproc-extensions.xpl" />
  <p:import href="css.xpl" />


  <p:declare-step type="epub:load-if-exists" name="load-if-exists">
    <p:option name="href" />
    <p:output port="result" primary="true" sequence="true"/>

    <p:try>
      <p:group>
        <p:load>
          <p:with-option name="href" select="$href" />
        </p:load>
      </p:group>
      <p:catch>
        <p:identity>
          <p:input port="source">
            <p:empty/>
          </p:input>
        </p:identity>
      </p:catch>
    </p:try>
  </p:declare-step>

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
    <p:string-replace match="/opfdir/text()">
      <p:input port="source">
        <p:inline>
          <opfdir>opfdir</opfdir>
        </p:inline>
      </p:input>
      <p:with-option name="replace" select="concat('''', replace(/*:container/*:rootfiles/*:rootfile/@full-path, '[^/]+$', ''), '''')">
        <p:pipe step="container" port="result" />
      </p:with-option>
    </p:string-replace>

    <p:add-attribute match="/*" attribute-name="opf-href"  name="opfdir">
      <p:with-option name="attribute-value" select="/*:container/*:rootfiles/*:rootfile/@full-path" />
    </p:add-attribute>


    <p:load>
      <p:with-option name="href" select="concat($epubdir, '/', /*:container/*:rootfiles/*:rootfile/@full-path)">
        <p:pipe step="container" port="result" />
      </p:with-option>
    </p:load>
  </p:declare-step>


  <!-- For loading a RNG or RNC schema. First try loading an XML file. If it fails, load it as data. 
       Since data does not accept a variable as href, we will use p:http-request on a file: resource as a workaround. --> 
  <p:declare-step type="epub:load-or-data" name="doc">
    <p:option name="href" />
    <p:output port="result" primary="true" />
    <p:try name="try">
      <p:group>
        <p:load>
          <p:with-option name="href" select="$href" />
        </p:load>
      </p:group>
      <p:catch name="catch">
        <p:identity>
          <p:input port="source">
            <p:inline>
              <c:request method="GET" detailed="false" /> 
            </p:inline>
          </p:input>
        </p:identity>
        <p:add-attribute match="/c:request" attribute-name="href">
          <p:with-option name="attribute-value" select="p:resolve-uri($href)" />
        </p:add-attribute>
        <p:http-request/>
        <p:rename match="/c:body" new-name="c:data" />
      </p:catch>
    </p:try>
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
    <p:option name="href" select="''"/>
    <p:option name="display-href" select="''" />
    <p:option name="epub-version" />
    <p:option name="content-type" />
    <p:output port="result" primary="true">
      <p:pipe step="doc" port="result" />
    </p:output>
    <p:output port="report" sequence="true">
      <p:pipe step="validations" port="report" />
    </p:output>
    <p:input port="source" primary="true"/>

    <!-- If $href is non-empty the document to be validated is read from the $href’d file,
         otherwise from the default readable port. Errors in loading or parsing these 
         data should be caught by invoking epub:validate-part in a try/catch clause. -->
    <epub:source-or-href-doc name="doc">
      <p:with-option name="href" select="if ($href ne '') then $href else ()" />
    </epub:source-or-href-doc>

    <!-- There may be more than one validation in the conf file. Iterate over all of them. -->
    <p:for-each name="validations">
      <p:iteration-source select="//validation[@target eq $content-type][@epubversion eq $epub-version]">
        <p:document href="../conf/versionmap.xml" />
      </p:iteration-source>
      <p:output port="report">
        <p:pipe step="try" port="report" />
      </p:output>

      <p:variable name="validation-type" select="/validation/@type" />
      <p:variable name="schema-file" select="/validation/@href" />
  
      <epub:load-or-data name="schema">
        <p:with-option name="href" select="$schema-file" />
      </epub:load-or-data>
  
      <p:try name="try">
        <p:group>
          <p:output port="report">
            <p:pipe step="ok" port="result" />
          </p:output>
  
          <p:add-attribute match="/*" attribute-name="href">
            <p:input port="source">
              <p:inline>
                <c:report>ok</c:report>
              </p:inline>
            </p:input>
            <p:with-option name="attribute-value" select="$href" />
          </p:add-attribute>
          <p:add-attribute match="/*" attribute-name="validation-type">
            <p:with-option name="attribute-value" select="$validation-type" />
          </p:add-attribute>
          <p:add-attribute match="/*" attribute-name="part" name="ok">
            <p:with-option name="attribute-value" select="$content-type" />
          </p:add-attribute>
  
          <p:choose>
            <p:when test="$validation-type = ('rng', 'rnc')">
              <p:validate-with-relax-ng>
                <p:input port="source">
                  <p:pipe step="doc" port="result"/>
                </p:input>
                <p:input port="schema">
                  <p:pipe step="schema" port="result"/>
                </p:input>
              </p:validate-with-relax-ng>
              <p:sink/>
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
              <p:sink/>
            </p:when>
            <p:when test="$validation-type eq 'schematron'">
              <p:validate-with-schematron assert-valid="false">
                <p:input port="source">
                  <p:pipe step="doc" port="result"/>
                </p:input>
                <p:input port="schema">
                  <p:pipe step="schema" port="result"/>
                </p:input>
                <p:input port="parameters">
                  <p:inline>
                    <c:param-set>
                      <c:param name="allow-foreign" value="true" />
                      <c:param name="select-contexts" value="//" />
                      <c:param name="visit-text" value="neither-true-nor-false" />
                    </c:param-set>
                  </p:inline>
                </p:input>
              </p:validate-with-schematron>
              <p:sink/>
            </p:when>
          </p:choose>
        </p:group>
        <p:catch name="catch1">
          <p:output port="report">
            <p:pipe port="result" step="fwd-errors"/>
          </p:output>
  
          <p:identity>
            <p:input port="source">
              <p:pipe step="catch1" port="error" />
            </p:input>
          </p:identity>
          <p:add-attribute match="/*" attribute-name="href">
            <p:with-option name="attribute-value" select="if ($display-href ne '') then $display-href else $href" />
          </p:add-attribute>
          <p:add-attribute match="/*" attribute-name="validation-type">
            <p:with-option name="attribute-value" select="$validation-type" />
          </p:add-attribute>
          <p:add-attribute match="/*" attribute-name="part" name="fwd-errors">
            <p:with-option name="attribute-value" select="$content-type" />
          </p:add-attribute>
          <p:sink/>
        </p:catch>
      </p:try>

    </p:for-each>


  </p:declare-step>


  <p:declare-step type="epub:validate-ncx" name="validate-ncx">
    <p:option name="epubdir" />
    <p:option name="opfdir" />
    <p:input port="source" primary="true" />
    <p:output port="result" primary="true" />
    <p:output port="report" sequence="true">
      <p:pipe step="try" port="report" />
    </p:output>

    <p:try name="try">
      <p:group>
        <p:output port="report" sequence="true">
          <p:pipe step="validate-part" port="report" />
        </p:output>
        <p:output port="result" primary="true"/>
        <epub:validate-part name="validate-part">
          <p:with-option name="href" select="concat($epubdir, '/', $opfdir, //opf:manifest/opf:item[@id eq 'ncx']/@href)" />
          <p:with-option name="display-href" select="//opf:manifest/opf:item[@id eq 'ncx']/@href" />
          <p:with-option name="epub-version" select="/*/@version" />
          <p:with-option name="content-type" select="'ncx'" />
        </epub:validate-part>
      </p:group>
      <p:catch name="catch1">
        <p:output port="report" sequence="true">
          <p:pipe port="result" step="fwd-errors"/>
        </p:output>
        <p:output port="result" primary="true">
          <p:pipe step="validate-ncx" port="source" />
        </p:output>
        <p:identity>
          <p:input port="source">
            <p:pipe step="catch1" port="error" />
          </p:input>
        </p:identity>
        <p:add-attribute match="/*" attribute-name="part">
          <p:with-option name="attribute-value" select="'ncx'" />
        </p:add-attribute>
        <p:add-attribute match="/*" attribute-name="step" name="fwd-errors">
          <p:with-option name="attribute-value" select="'find'" />
        </p:add-attribute>
        
        <p:sink/>
      </p:catch>
    </p:try>
  </p:declare-step>

  <p:declare-step type="epub:validate-opf" name="validate-opf">
    <p:input port="source" primary="true" />
    <p:output port="result" primary="true" />
    <p:output port="report" sequence="true">
      <p:pipe step="try" port="report" />
    </p:output>

    <p:try name="try">
      <p:group>
        <p:output port="report" sequence="true">
          <p:pipe step="validate-part" port="report" />
        </p:output>
        <p:output port="result" primary="true"/>
        <epub:validate-part name="validate-part">
          <p:with-option name="epub-version" select="/*/@version" />
          <p:with-option name="content-type" select="'opf'" />
          <p:with-option name="display-href" select="//opf:manifest/opf:item[@id eq 'ncx']/@href" />
        </epub:validate-part>
      </p:group>
      <p:catch name="catch1">
        <p:output port="report" sequence="true">
          <p:pipe port="result" step="fwd-errors"/>
        </p:output>
        <p:output port="result" primary="true">
          <p:pipe step="validate-opf" port="source" />
        </p:output>
        <p:identity>
          <p:input port="source">
            <p:pipe step="catch1" port="error" />
          </p:input>
        </p:identity>
        <p:add-attribute match="/*" attribute-name="part">
          <p:with-option name="attribute-value" select="'opf'" />
        </p:add-attribute>
        <p:add-attribute match="/*" attribute-name="step" name="fwd-errors">
          <p:with-option name="attribute-value" select="'find'" />
        </p:add-attribute>
        
        <p:sink/>
      </p:catch>
    </p:try>
  </p:declare-step>


  <p:declare-step type="epub:validate-spinecontent" name="validate-spinecontent">
    <p:input port="opf" primary="true" />
    <p:option name="epubdir" />
    <p:option name="opfdir" />
    <p:output port="result" primary="true">
      <p:pipe step="wrap-spineconents" port="result" />
    </p:output>
    <p:output port="report" sequence="true">
      <p:pipe step="for-each" port="report" />
    </p:output>

    <p:for-each name="for-each">
      <p:output port="result" primary="true" />
      <p:output port="report" sequence="true">
        <p:pipe step="validate-part" port="report" />
      </p:output>

      <p:iteration-source select="//opf:spine/*" />
      <p:variable name="id" select="/*/@idref"/>
      <p:variable name="filename" select="//opf:manifest/opf:item[@id eq $id]/@href">
        <p:pipe step="validate-spinecontent" port="opf" />
      </p:variable>

      <epub:validate-part name="validate-part">
        <p:with-option name="epub-version" select="/*/@version">
          <p:pipe step="validate-spinecontent" port="opf"/>
        </p:with-option>
        <p:with-option name="content-type" select="'spine-html'" />
        <p:with-option name="href" select="concat($epubdir, '/', $opfdir, $filename)" />
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
    <p:output port="report" sequence="true">
      <p:pipe step="for-each" port="report" />
    </p:output>

    <p:for-each name="for-each">
      <p:output port="result" primary="true" />
      <p:output port="report" sequence="true" />
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


  <p:declare-step type="epub:schematron-spinehtml" name="schematron-spinehtml">
    <p:option name="schematron" />
    <p:option name="xsl" select="'../xsl/svrl2xsl.xsl'" />

    <p:input port="source" primary="true" />
    <p:input port="l10n" sequence="true" />
    <p:input port="schematron" />
    <p:output port="result" primary="true">
      <p:pipe step="patch" port="result" />
    </p:output>
    <p:output port="report">
      <p:pipe step="schematron" port="report" />
    </p:output>

    <p:load name="load-schematron">
      <p:with-option name="href" select="$schematron" />
    </p:load>
    <p:load name="load-xsl">
      <p:with-option name="href" select="$xsl" />
    </p:load>

    <p:validate-with-schematron name="schematron" assert-valid="false">
<!--     <p:log port="report" href="schematron.xml"/> -->

      <p:input port="source">
        <p:pipe step="schematron-spinehtml" port="source" />
      </p:input>
      <p:input port="schema">
        <p:pipe step="load-schematron" port="result"/>
      </p:input>
      <p:input port="parameters">
        <p:inline>
          <c:param-set>
            <c:param name="allow-foreign" value="true" />
            <c:param name="select-contexts" value="//" />
            <c:param name="visit-text" value="neither-true-nor-false" />
          </c:param-set>
        </p:inline>
      </p:input>
    </p:validate-with-schematron>

    <p:sink/>

    <p:xslt name="create-patch-xsl">
      <p:input port="source">
  	    <p:pipe step="schematron" port="report"/>
  	    <p:pipe step="schematron-spinehtml" port="l10n"/>
      </p:input>
      <p:input port="stylesheet">
        <p:pipe step="load-xsl" port="result"/>
      </p:input>
      <p:input port="parameters">
        <p:inline>
          <c:param name="lang" value="$lang" />
        </p:inline>
      </p:input>
    </p:xslt>
    <p:sink/>


    <p:xslt name="patch">
      <p:input port="source">
        <p:pipe step="schematron-spinehtml" port="source" />
      </p:input>
      <p:input port="stylesheet">
        <p:pipe step="create-patch-xsl" port="result" />
      </p:input>
      <p:input port="parameters"><p:empty/></p:input>
    </p:xslt>
  </p:declare-step>


  <p:declare-step type="epub:render-plain-reports" name="plain-reports">
    <p:option name="xsl" select="'../xsl/plain-html-report.xsl'" />
    <p:option name="schematron-content-links" select="'true'" />

    <p:input port="source" primary="true" sequence="true"/>
    <p:input port="l10n" sequence="true" />
    <p:output port="result" primary="true" sequence="true">
      <p:pipe step="render" port="result" />
    </p:output>

    <p:load name="load-xsl">
      <p:with-option name="href" select="$xsl"><p:empty/></p:with-option>
    </p:load>

    <p:xslt name="render" template-name="main">
      <p:input port="source">
        <p:pipe step="plain-reports" port="source" />
      </p:input>
      <p:input port="stylesheet">
        <p:pipe step="load-xsl" port="result" />
      </p:input>
      <p:input port="parameters">
        <p:inline>
          <c:param-set>
            <c:param name="schematron-content-links" value="$schematron-content-links" />
          </c:param-set>
        </p:inline>
      </p:input>
    </p:xslt>

  </p:declare-step>

  <p:declare-step type="epub:htmlreport" name="htmlreport">
    <p:input port="source" primary="true" sequence="true"/>
    <p:output port="result" primary="true">
      <p:pipe step="assemble" port="result" />
    </p:output>

    <p:xslt name="assemble" template-name="main">
      <p:input port="source">
        <p:pipe step="htmlreport" port="source" />
      </p:input>
      <p:input port="stylesheet">
        <p:document href="../xsl/assemble-reports.xsl" />
      </p:input>
      <p:input port="parameters"><p:empty/></p:input>
    </p:xslt>
  </p:declare-step>
  
  <p:declare-step name="opf-check-filerefs" type="epub:opf-check-filerefs">
    
    <!-- * This pipeline verifies if referenced files existing in the epub and   
      * existing files are referenced in the opf
      * 
      * invoke with 
      * java -jar ../calabash/calabash.jar opf-check-filerefs.xpl epubfile=../test/OPFIllegalFileref.epub
      * java -jar ../calabash/calabash.jar opf-check-filerefs.xpl epubfile=../test/Unmanifested.epub
      * 
      * -->
    
    <p:input port="source"/>
    <p:output port="result"/>
    
    <p:output port="report" sequence="true">
      <p:pipe step="check-filerefs" port="result" />
    </p:output>
    
    
    <p:option name="epubfile"/>
    
    <p:import href="../lib/xproc-extensions.xpl"/>
    <p:import href="unzip.xpl"/>
    
    <epub:opf name="opfload">
      <p:with-option name="epubfile" select="$epubfile" />
    </epub:opf>
    
    
    <cx:unzip content-type="application/epub+zip" name="epubdir">
      <p:with-option name="href" select="$epubfile"/>
    </cx:unzip>
    
    <p:wrap-sequence wrapper="epub">
      <p:input port="source">
        <p:pipe port="result" step="opfload"/>
        <p:pipe port="result" step="epubdir"/>
      </p:input>
    </p:wrap-sequence>
    <p:xslt name="check-filerefs">
      <p:input port="stylesheet">
        <p:document href="../xsl/opf-check-filerefs.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:xslt>
    
  </p:declare-step>
  
  

</p:library>

