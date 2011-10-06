<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cx="http://xmlcalabash.com/ns/extensions" 
    xmlns:epub="http://www.idpf.org/2007/ops"
    xmlns:opf="http://www.idpf.org/2007/opf" 
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:css="http://www.w3.org/1996/css" 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0">
    <p:documentation>
        Basic Pipeline to test the implementation of Jing. 
        
        Invoke from epubcheck-xproc dir with 
        "calabash xproc/test-validate.xpl schema=rng/xhtml-strict.rng input=test/test.html jing=calabash/lib/jing.jar catalog=resolver/catalog.xml"
    </p:documentation>
    
    <p:import href="validate.xpl"/>
    
    <epub:validate-with-jing>
        <p:with-option name="input" select="$input"/>
        <p:with-option name="schema" select="$schema"/>
        <p:with-option name="jing" select="$jing"/>
        <p:with-option name="catalog" select="$catalog"/>
    </epub:validate-with-jing>
    
</p:pipeline>