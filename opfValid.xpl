<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:cx="http://xmlcalabash.com/ns/extensions" 
    xmlns:opf="http://www.idpf.org/2007/opf"
    version="1.0">
    <!--   * 
           * This step is used to validate the OPF file and perform some checks with Schematron 
           * Martin Kraetke, 22.8.2011
           * 
           * -->
    
    
	<!--   * 
	       * define standard i/o 
	       * -->
	<p:input port="source" sequence="true">
		<p:empty/>
	</p:input>
	<p:input port="opf" sequence="true">
		<p:empty/>
	</p:input>

	<p:output port="result" sequence="true"/>

    <!--    * 
            * write output to log 
            * -->
    <p:log port="result" href="log/opf.log"/>

	<!--   * 
	       * load extension library for unzip 
	       * -->
	<p:import href="lib/xproc-extensions.xpl"/>

	<!--   *
	       * unzip opf and declare as step opf 
	       * -->
    <cx:unzip href="test/OPFIllegalFileref.epub" file="OEBPS/content.opf" name="opfInput"/>

	<!--   *
	       * validate opf with corresponding Relax NG schema, assert-value is true in order to cancel processing 
	       * -->
	<p:validate-with-relax-ng name="opfValidate" assert-valid="false">
		<p:input port="schema">
			<p:document href="rng/opf.rng"/>
		</p:input>
	</p:validate-with-relax-ng>

	<!--   *
	       * discard sequence in order to avoid static error while loading the epub
	       * -->
	<p:sink/>

	<!--   *
	       * epub directory listing and declare as step epub. this is needed in order to load the document from later points of this workflow 
	       * -->
    <cx:unzip href="test/OPFIllegalFileref.epub" name="epub"/>

	<!--   * 
	       * combine epub directory listing and opf in one xml sequence, new root element is named 'global'
	       * -->
	<p:pack wrapper="global" name="merge">
		<p:input port="source">
			<p:pipe port="result" step="opfInput"/>
		</p:input>
	</p:pack>

    <!--    * 
            * stylesheet returns any elements with references to files not to be found in the ebup and vice versa     
            * -->
    <p:xslt>
        <p:input port="source"/>
        <p:input port="stylesheet" select="/*">
            <p:document href="xsl/filerefs.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
    


</p:declare-step>
