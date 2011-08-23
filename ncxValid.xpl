<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:cx="http://xmlcalabash.com/ns/extensions" 
    xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
    xmlns:sch="http://www.ascc.net/xml/schematron"
    version="1.0">
    <!--   * 
           * This step is used to validate the NCX file and perform some checks with Schematron 
           * Martin Kraetke, 22.8.2011
           * 
           * -->
    
    
	<!--   * 
	       * define standard i/o 
	       * -->
	<p:input port="source" sequence="true">
		<p:empty/>
	</p:input>
	<p:input port="ncx" sequence="true">
		<p:empty/>
	</p:input>

	<p:output port="result" sequence="true"/>

    <!--    * 
            * write output to log 
            * -->
    <p:log port="result" href="log/ncx.log"/>

	<!--   * 
	       * load extension library for unzip 
	       * -->
	<p:import href="lib/xproc-extensions.xpl"/>

	<!--   *
	       * unzip opf and declare as step opf 
	       * -->
	
	<cx:unzip href="test/Sample.epub" file="OEBPS/toc.ncx" name="ncxInput"/>
	
	
	<!--   *
	       * validate opf with corresponding Relax NG schema, assert-value is true in order to cancel processing 
	       * -->
	<p:validate-with-relax-ng name="ncxValidate" assert-valid="true">
		<p:input port="schema">
			<p:document href="rng/ncx.rng"/>
		</p:input>
	</p:validate-with-relax-ng>

	<!--   *
	       * validate with Schematron 1.5, Calabash doesn't support ISO Schematron
	       * 	COMMENT: 
	       
	 
	<p:sink/>
	<p:validate-with-schematron assert-valid="false">
		<p:input port="source">
			<p:document href="test\test\OEBPS\toc.ncx"/>
		</p:input>  
		<p:input port="schema">
			<p:document href="sch/ncx.sch"/>
		</p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
	</p:validate-with-schematron>
	-->

	
	
	
</p:declare-step>
