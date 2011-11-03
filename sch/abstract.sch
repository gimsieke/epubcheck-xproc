<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:s="http://purl.oclc.org/dsdl/schematron">
  <!-- *
       * This file will incorporate all patterns 
       * 
       *  
       * -->

  <s:ns uri="http://www.w3.org/1996/css" prefix="css"/>

  <s:pattern abstract="true" id="css-policy">

    <s:rule context="$position">
      <s:report test="$position-static"><s:span class="severity">WRN</s:span> <s:span class="msgid">SCH_0077</s:span> <s:name/> is not supported</s:report>
      <s:report test="$position-absolute"><s:span class="severity">WRN</s:span> <s:span class="msgid">SCH_0077</s:span> <s:name/> is not supported</s:report>
      <s:report test="$position-relative"><s:span class="severity">WRN</s:span> <s:span class="msgid">SCH_0077</s:span> <s:name/> is not supported</s:report>
      <s:report test="$position-fixed"><s:span class="severity">WRN</s:span> <s:span class="msgid">SCH_0077</s:span> <s:name/> is not supported</s:report>      
    </s:rule>
    
  </s:pattern>
  
  <s:pattern is-a="css-policy">
    <s:param name="position-absolute" value="@css:position eq 'absolute'"/>
    
    
  </s:pattern>

</s:schema>
