<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0">
    <p:documentation>
        Basic Pipeline to test the implementation of Jing. 
        
        Invoke from epubcheck-xproc dir with 
        "calabash xproc/test-validate.xpl schema=rng/xhtml-strict.rng input=test/test.html jing=calabash/lib/jing.jar catalog=resolver/catalog.xml"
    </p:documentation>
    
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