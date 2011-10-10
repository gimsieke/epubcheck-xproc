<?xml version="1.0" encoding="UTF-8"?>
<s:schema
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:s="http://purl.oclc.org/dsdl/schematron"
  >

  <s:ns uri="http://www.w3.org/1996/css" prefix="css"/>

  <!-- *
       * font rules 
       * -->
  <s:pattern id="css-font">
    <s:rule context="*[@css:font-family]">
      <s:report test="@css:font-family">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0001</s:span>
        font-family not supported (<s:value-of select="@css:font-family"/>)
      </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+em$')]">
      <s:report test="replace(@css:font-size, 'em$', '') cast as xs:double gt 2">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0002</s:span>
        Font sizes larger than 2em are without effect (<s:value-of select="@css:font-size"/>)
      </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+px$')]">
      <s:report test="replace(@css:font-size, 'px$', '') cast as xs:double gt 48">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0003</s:span>
        Font sizes larger than 48px are without effect (<s:value-of select="@css:font-size"/>)
      </s:report>
    </s:rule>
  </s:pattern>
    
  <!-- *
       * text rules 
       * -->
    <s:pattern id="css-text">
        <s:rule context="*[@css:text-transform]">
            <s:report test="@css:text-transform eq 'lowercase'">
                text-transform:lowercase not supported
            </s:report>
            <s:report test="@css:text-transform eq 'uppercase'">
                text-transform:uppercase not supported
            </s:report>
            <s:report test="@css:text-transform eq 'capitalize'">
                text-transform:capitalize not supported
            </s:report>
        </s:rule>
        <s:rule context="*[@css:text-decoration]">
            <s:report test="@css:text-decoration eq 'overline'">
                text-decoration:overline not supported
            </s:report>
            <s:report test="@css:text-decoration eq 'blink'">
                text-decoration:blink not supported
            </s:report>
        </s:rule>
    </s:pattern>
    <!--    *
            * padding rules 
            * -->    
    <s:pattern id="css-padding">
        <s:rule context="*[@css:padding]">
            <s:report test="@css:padding">
                padding not supported
            </s:report>
        </s:rule>
        <s:rule context="*[@css:padding-right]">
            <s:report test="@css:padding-right">
                padding-right not supported
            </s:report>
        </s:rule>
        <s:rule context="*[@css:padding-left]">
            <s:report test="@css:padding-left">
                padding-left not supported
            </s:report>
        </s:rule>
        <s:rule context="*[@css:padding-bottom]">
            <s:report test="@css:padding-bottom">
                padding-bottom not supported
            </s:report>
        </s:rule>
        <s:rule context="*[@css:padding-top]">
            <s:report test="@css:padding-top">
                padding-top not supported
            </s:report>
        </s:rule>
    </s:pattern>
    <!--    *
            * float rules 
            * -->    
    <s:pattern id="css-floats">
        <s:rule context="*[@css:float]">
            <s:report test="@css:float">
                float not supported
            </s:report>
        </s:rule>
        <s:rule context="*[@css:clear]">
            <s:report test="@css:clear">
                clear not supported
            </s:report>
        </s:rule>
    </s:pattern>
</s:schema>
