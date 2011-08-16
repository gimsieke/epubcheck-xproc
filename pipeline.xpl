<?xml version="1.0"?>
<p:pipeline 
    name="testUnzip"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"  
    xmlns:cx="http://xmlcalabash.com/ns/extensions"
    xmlns:opf="http://www.idpf.org/2007/opf"
    version="1.0">
    
    <p:import href="lib/xproc-extensions.xpl"/>
    <cx:unzip file="OEBPS/content.opf" href="test/Sample.epub" />
    
    

</p:pipeline>