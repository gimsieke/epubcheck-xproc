<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:s="http://purl.oclc.org/dsdl/schematron"
    xmlns:css="http://www.w3.org/1996/css"
    xmlns:html="http://www.w3.org/1999/xhtml"
    version="1.0">
    <p:input port="source">
        <p:document href="css.xml"/>
    </p:input>
    <p:output port="result"/>
    
    
    <p:identity name="identity"/>
    
    <p:validate-with-schematron assert-valid="false">
        <p:log port="report" href="schematron.xml"/>
        <p:input port="schema">
            <p:document href="abstract.sch"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="source">
            <p:pipe port="result" step="identity"/>
        </p:input>
    </p:validate-with-schematron>
    
</p:declare-step>