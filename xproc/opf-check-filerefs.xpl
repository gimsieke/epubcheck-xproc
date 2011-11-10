<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:cx="http://xmlcalabash.com/ns/extensions"
    xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:epub="http://www.idpf.org/2007/ops"
    version="1.0">

    <!-- * This pipeline verifies if referenced files existing in the epub and   
         * existing files are referenced in the opf
         * 
         * invoke with 
         * java -jar ../calabash/calabash.jar opf-check-filerefs.xpl epubfile=../test/OPFIllegalFileref.epub
         * java -jar ../calabash/calabash.jar opf-check-filerefs.xpl epubfile=../test/Unmanifested.epub
         * 
         * -->

    <p:input port="source"/>
<!-- for testing 
    <p:output port="result">
        <p:pipe port="report" step="opf-check-filerefs"/>
    </p:output>
    
-->
    <p:output port="result"/>
    <p:output port="report"/>
    
    <p:option name="epubfile"/>

    <p:import href="epub.xpl"/>
    
    <epub:opf-check-filerefs name="opf-check-filerefs">
        <p:with-option name="epubfile" select="$epubfile"/>
    </epub:opf-check-filerefs>

</p:declare-step>