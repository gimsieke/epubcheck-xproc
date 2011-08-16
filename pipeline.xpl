<?xml version="1.0"?>
<p:declare-step 
    name="testUnzip"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"  
    xmlns:cx="http://xmlcalabash.com/ns/extensions"
    version="1.0">
    
    <p:import href="lib/xproc-extensions.xpl"/>
    

    <p:input port="source">  
        <cx:unzip file="OEBPS/content.opf" href="test/test.epub" />  
    </p:input>  
    
    <p:output port="result" sequence="true"/>
    <p:filter select="/package/spine"/>  
    
    
    

</p:declare-step>