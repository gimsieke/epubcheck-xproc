<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0"
    >
    
    <p:option name="jing-path"/>
    <p:option name="src-path"/>
    <p:option name="schema-path"/>
    
    <p:input port="source">
        <p:empty/>
    </p:input>
    <p:output port="result">
        <p:pipe port="result" step="validate-with-rng"/>
    </p:output>
    <p:exec command="java"  name="validate-with-rng"
        result-is-xml="false" wrap-result-lines="true">
        <p:with-option name="args" select="concat('-jar ', $jing-path, ' ',
            $schema-path, ' ', $src-path)">
            <p:empty/>
        </p:with-option>
    </p:exec>

</p:declare-step>