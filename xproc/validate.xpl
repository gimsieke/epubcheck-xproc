<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cx="http://xmlcalabash.com/ns/extensions" 
    xmlns:epub="http://www.idpf.org/2007/ops"
    xmlns:opf="http://www.idpf.org/2007/opf" 
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:css="http://www.w3.org/1996/css" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    version="1.0">

    <p:declare-step type="epub:validate-with-jing" name="validate-with-jing">
        
        <p:option name="input"/>
        <p:option name="schema"/>
        <p:option name="jing"/>
        <p:option name="catalog"/>
        <p:input port="source"/>
        <p:output port="result"/>
        
        <p:exec command="java"
            source-is-xml="true"
            result-is-xml="false"
            wrap-result-lines="true"> 
            <p:with-option name="args" select="concat('-jar ', $jing,' -C ',$catalog,' ',$schema,' ',$input)"/>
        </p:exec>
        
        <p:rename match="c:result" new-name="report"/>
        <p:rename match="c:line" new-name="error"/>

    </p:declare-step>
</p:library>
