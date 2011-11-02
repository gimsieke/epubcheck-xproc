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
    <p:output port="result"/>
    
    <p:option name="epubfile"/>
    
    <p:import href="../lib/xproc-extensions.xpl"/>
    <p:import href="unzip.xpl"/>

    <epub:opf name="opf">
        <p:with-option name="epubfile" select="$epubfile" />
    </epub:opf>
    
    <cx:unzip content-type="application/epub+zip" name="epubdir">
        <p:with-option name="href" select="$epubfile"/>
    </cx:unzip>
    
    <p:wrap-sequence wrapper="epub">
        <p:input port="source">
            <p:pipe port="result" step="opf"/>
            <p:pipe port="result" step="epubdir"/>
        </p:input>
        <p:log port="result" href="log.xml"/>
    </p:wrap-sequence>
    
     
    <p:xslt name="check-filerefs">
        <p:input port="stylesheet">
            <p:document href="../xsl/opf-check-filerefs.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
</p:declare-step>