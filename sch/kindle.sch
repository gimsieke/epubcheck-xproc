<?xml version="1.0" encoding="UTF-8"?>
<s:schema
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:s="http://purl.oclc.org/dsdl/schematron"
  >

  <s:ns uri="http://www.w3.org/1996/css" prefix="css"/>

  <s:pattern id="css-position">
    <s:rule context="*[@css:position]">
      <s:report test="@css:position = 'fixed'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0016</s:span>
        position:fixed not supported
      </s:report>
      <s:report test="@css:position = 'absolute'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0017</s:span>
        position:absolute not supported
      </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * font rules 
       * -->
  <s:pattern id="css-font">
    <s:rule context="*[@css:font-family]">
      <s:report test="@css:font-family">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0001</s:span>
        font-family not supported (<s:span class="info"><xsl:value-of select="@css:font-family"/></s:span>)
      </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+em$')]">
      <s:report test="replace(@css:font-size, 'em$', '') cast as xs:double gt 2">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0002</s:span>
        Font sizes larger than 2em are without effect (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>)
      </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+px$')]">
      <s:report test="replace(@css:font-size, 'px$', '') cast as xs:double gt 40">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0003</s:span>
        Font sizes larger than 40px are without effect (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>)
      </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+pt$')]">
      <s:report test="replace(@css:font-size, 'px$', '') cast as xs:double gt 30">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0018</s:span>
        Font sizes larger than 30pt are without effect (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>)
      </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+pc$')]">
      <s:report test="replace(@css:font-size, 'px$', '') cast as xs:double gt 2.5">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0019</s:span>
        Font sizes larger than 2.5pc are without effect (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>)
      </s:report>
    </s:rule>
    
  </s:pattern>
    
  <!-- *
       * text rules 
       * -->
  <s:pattern id="css-text">
    <s:rule context="*[@css:text-transform]">
      <s:report test="@css:text-transform eq 'lowercase'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0004</s:span>
        text-transform:lowercase not supported
      </s:report>
      <s:report test="@css:text-transform eq 'uppercase'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0005</s:span>
        text-transform:uppercase not supported
      </s:report>
      <s:report test="@css:text-transform eq 'capitalize'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0006</s:span>
        text-transform:capitalize not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:text-decoration]">
      <s:report test="@css:text-decoration eq 'overline'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0007</s:span>
        text-decoration:overline not supported
      </s:report>
      <s:report test="@css:text-decoration eq 'blink'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0008</s:span>
        text-decoration:blink not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * padding rules 
       * -->    
  <s:pattern id="css-padding">
    <s:rule context="*[@css:padding]">
      <s:report test="@css:padding">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0009</s:span>
        padding not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-right]">
      <s:report test="@css:padding-right">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0010</s:span>
        padding-right not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-left]">
      <s:report test="@css:padding-left">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0011</s:span>
        padding-left not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-bottom]">
      <s:report test="@css:padding-bottom">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0012</s:span>
        padding-bottom not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-top]">
      <s:report test="@css:padding-top">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0013</s:span>
        padding-top not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * float rules 
       * -->    
  <s:pattern id="css-floats">
    <s:rule context="*[@css:float]">
      <s:report test="@css:float">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0014</s:span>
        float not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:clear]">
      <s:report test="@css:clear">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0015</s:span>
        clear not supported
      </s:report>
    </s:rule>
  </s:pattern>
  
  <!-- *
       * font-variant 
       * -->
  <s:pattern id="font-variant">
    <s:rule context="*[@css:font-variant]">
      <s:report test="@css:font-variant eq 'small-caps'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0020</s:span>
        font-variant:small-caps not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
    * spacing
    * -->
  <s:pattern id="spacing">
    <s:rule context="*[@css:word-spacing]">
      <s:report test="@css:word-spacing">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0021</s:span>
        word-spacing not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:letter-spacing]">
      <s:report test="@css:letter-spacing">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0022</s:span>
        letter-spacing not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:line-height]">
      <s:report test="@css:line-height">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0023</s:span>
        line-height not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
      * lists
      * -->
  <s:pattern id="list-style-type">
    <s:rule context="*[@css:list-style-type]">
      <s:report test="@css:list-style-type eq 'decimal'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0024</s:span>
        list-style-type:decimal is not required. A regular decimal list marker is displayed per default
      </s:report>
      <s:report test="@css:list-style-type eq 'lower-roman'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0025</s:span>
        list-style-type:lower-roman not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'upper-roman'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0026</s:span>
        list-style-type:upper-roman not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'lower-alpha'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0027</s:span>
        list-style-type:lower-alpha not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'upper-alpha'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0028</s:span>
        list-style-type:upper-alpha not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'lower-greek'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0029</s:span>
        list-style-type:lower-greek not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'disc'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0030</s:span>
        list-style-type:disc is not required. A regular disc list marker is displayed per default
      </s:report>
      <s:report test="@css:list-style-type eq 'circle'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0031</s:span>
        list-style-type:circle not supported. A regular disc list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'square'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0032</s:span>
        list-style-type:square not supported. A regular disc list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'none'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0033</s:span>
        list-style-type:none not supported. A regular disc list marker is displayed instead
      </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-position]">
      <s:report test="@css:list-style-position eq 'inside'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0034</s:span>
        list-style-position:inside is not supported. The position of the list markers is always displayed outside the content flow
      </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-position]">
      <s:report test="@css:list-style-position eq 'outside'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0035</s:span>
        list-style-position:outside is not required. The position of the list markers is always displayed outside the content flow
      </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-image]">
      <s:report test="@css:list-style-image">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0036</s:span>
        list-style-image is not supported. A regular disc list marker is displayed instead
      </s:report>
    </s:rule>
  </s:pattern>
  
  
</s:schema>
