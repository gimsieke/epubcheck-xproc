<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0">
    
    <p:documentation>
        Basic Pipeline to test the implementation of Jing. 
        Unfortunately Calabash doesn't support the p:exec 
        step with args of different types. Kindly see issue 
        https://github.com/ndw/xmlcalabash1/issues/9
    </p:documentation>
    
    <p:option name="input"/>
    <p:option name="schema"/>
    
    <p:input port="source"/>
    <p:output port="result"/>
    
    <p:exec command="java"
        source-is-xml="true"
        result-is-xml="false"
        wrap-result-lines="true"
        arg-separator=","> 
        <p:with-option name="args" select="concat('-jar ../calabash/lib/jing.jar -C ../resolver/catalog.xml', ' ', $schema,' ',$input)"/>
    </p:exec>

    <p:identity/>

</p:declare-step>







<!-- hardcoded <p:with-option name="args" select="'-jar ../calabash/lib/jing.jar -C ../resolver/catalog.xml ../rng/xhtml-basic.rng test.html'"/>
    <p:with-option name="args" select="'-jar ../calabash/lib/jing.jar -C ../resolver/catalog.xml' $schema $input"/>
-->