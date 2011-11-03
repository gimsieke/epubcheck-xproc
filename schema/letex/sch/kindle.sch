<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:s="http://purl.oclc.org/dsdl/schematron">
  <!-- *
       * Schematron profile for Kindle, Kindle DX and Kindle App for iPad/iPhone/iPod Touch
       * 
       * Note: in a further version, the checks for Kindle App can be found in a separate file 
       * -->

  <s:ns uri="http://www.w3.org/1996/css" prefix="css"/>

  <s:pattern id="css-position">
    <s:rule context="*[@css:position]">
      <s:report test="@css:position eq 'fixed'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0001</s:span> position:fixed not supported </s:report>
      <s:report test="@css:position eq 'absolute'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0002</s:span> position:absolute not supported </s:report>
      <s:report test="@css:position eq 'relative'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0003</s:span> position:relative not supported </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * FONT-FAMILIES 
       * -->
  <s:pattern id="font-family">
    <s:rule context="*[@css:font-family]">
      <s:report test="@css:font-family eq 'sans-serif'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0004</s:span> font-family:sans-serif is not supported. </s:report>
      <s:report test="@css:font-family eq 'cursive'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0005</s:span> font-family:cursive is not supported. </s:report>
      <s:report test="@css:font-family eq 'fantasy'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0006</s:span> font-family:fantasy is not supported. </s:report>
      <s:report test="@css:font-family">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_Kindle_0007</s:span> Individual fonts are not supported. Kindle
        uses a serif font per default, except the following tags where a monospace font is used:
        pre, code, samp, kbd, tt </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * FONT SIZING
       * -->
  <s:pattern id="css-font-size">
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+em$')]">
      <s:report test="replace(@css:font-size, 'em$', '') cast as xs:double gt 2">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0008</s:span> Font sizes larger than 2em are without effect
          (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>) </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+px$')]">
      <s:report test="replace(@css:font-size, 'px$', '') cast as xs:double gt 40">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0009</s:span> Font sizes larger than 40px are without
        effect (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>) </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+pt$')]">
      <s:report test="replace(@css:font-size, 'px$', '') cast as xs:double gt 30">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0010</s:span> Font sizes larger than 30pt are without
        effect (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>) </s:report>
    </s:rule>
    <s:rule context="*[@css:font-size][matches(., '^[0-9.]+pc$')]">
      <s:report test="replace(@css:font-size, 'px$', '') cast as xs:double gt 2.5">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0011</s:span> Font sizes larger than 2.5pc are without
        effect (<s:span class="info"><xsl:value-of select="@css:font-size"/></s:span>) </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * TEXT 
       * -->
  <s:pattern id="css-text">
    <s:rule context="*[@css:text-transform]">
      <s:report test="@css:text-transform eq 'lowercase'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0012</s:span> text-transform:lowercase not supported </s:report>
      <s:report test="@css:text-transform eq 'uppercase'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0013</s:span> text-transform:uppercase not supported </s:report>
      <s:report test="@css:text-transform eq 'capitalize'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0014</s:span> text-transform:capitalize not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:text-decoration]">
      <s:report test="@css:text-decoration eq 'overline'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0015</s:span> text-decoration:overline not supported </s:report>
      <s:report test="@css:text-decoration eq 'blink'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0016</s:span> text-decoration:blink not supported
      </s:report>
    </s:rule>


  </s:pattern>

  <!-- *
       * BOX MODEL 
       * -->
  <s:pattern id="css-padding">
    <s:rule context="*[@css:padding]">
      <s:report test="@css:padding">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0017</s:span> padding not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-right]">
      <s:report test="@css:padding-right">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0018</s:span> padding-right not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-left]">
      <s:report test="@css:padding-left">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0019</s:span> padding-left not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-bottom]">
      <s:report test="@css:padding-bottom">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0020</s:span> padding-bottom not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:padding-top]">
      <s:report test="@css:padding-top">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0021</s:span> padding-top not supported </s:report>
    </s:rule>
  </s:pattern>
  <s:pattern id="border-model">
    <s:rule context="*[@css:border-top]">
      <s:report test="@css:border-top">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0022</s:span> border-top not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:border-right]">
      <s:report test="@css:border-right">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0023</s:span> border-right not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:border-bottom]">
      <s:report test="@css:border-bottom">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0024</s:span> border-bottom not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:border-left]">
      <s:report test="@css:border-left">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0025</s:span> border-left not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:border]">
      <s:report test="@css:border">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0026</s:span> border is not supported</s:report>
    </s:rule>
  </s:pattern>
  <s:pattern id="border-style">
    <s:rule context="*[@css:border-top-style]">
      <s:report test="@css:border-top-style">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0027</s:span> border-top-style is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:border-right-style]">
      <s:report test="@css:border-right-style">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0028</s:span> border-right-style is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-bottom-style]">
      <s:report test="@css:border-bottom-style">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0029</s:span> border-bottom-style is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-left-style]">
      <s:report test="@css:border-left-style">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0030</s:span> border-left-style is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-style]">
      <s:report test="@css:border-style">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0031</s:span> border-style is not supported on Kindle and
        Kindle DX. </s:report>
    </s:rule>
  </s:pattern>
  <s:pattern id="border-width">
    <s:rule context="*[@css:border-top-width]">
      <s:report test="@css:border-top-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0032</s:span> border-top-width is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:border-right-width]">
      <s:report test="@css:border-right-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0033</s:span> border-right-width is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-bottom-width]">
      <s:report test="@css:border-bottom-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0034</s:span> border-bottom-width is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-left-width]">
      <s:report test="@css:border-left-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0035</s:span> border-left-width is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-width]">
      <s:report test="@css:border-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0036</s:span> border-width is not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <s:pattern id="border-color">
    <s:rule context="*[@css:border-top-color]">
      <s:report test="@css:border-top-color">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0037</s:span> border-top-color is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:border-right-color]">
      <s:report test="@css:border-right-color">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0038</s:span> border-right-color is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-bottom-color]">
      <s:report test="@css:border-bottom-color">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0039</s:span> border-bottom-color is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-left-color]">
      <s:report test="@css:border-left-color">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0040</s:span> border-left-color is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-color]">
      <s:report test="@css:border-color">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0041</s:span> border-width is not supported
      </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * FLOATS 
       * -->
  <s:pattern id="css-floats">
    <s:rule context="*[@css:float]">
      <s:report test="@css:float">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0042</s:span> float not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:clear]">
      <s:report test="@css:clear">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0043</s:span> clear not supported </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * FONT-VARIANT
       * -->
  <s:pattern id="font-variant">
    <s:rule context="*[@css:font-variant]">
      <s:report test="@css:font-variant eq 'small-caps'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0044</s:span> font-variant:small-caps not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * SPACING
       * -->
  <s:pattern id="spacing">
    <s:rule context="*[@css:word-spacing]">
      <s:report test="@css:word-spacing">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0045</s:span> word-spacing not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:letter-spacing]">
      <s:report test="@css:letter-spacing">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0046</s:span> letter-spacing not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:line-height]">
      <s:report test="@css:line-height">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0047</s:span> line-height not supported </s:report>
    </s:rule>
  </s:pattern>
  <!--  *
        * LISTS
        * -->
  <s:pattern id="list-style-type">
    <s:rule context="*[@css:list-style-type]">
      <s:report test="@css:list-style-type eq 'decimal'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0048</s:span> list-style-type:decimal is not required. A
        regular decimal list marker is displayed per default </s:report>
      <s:report test="@css:list-style-type eq 'lower-roman'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0049</s:span> list-style-type:lower-roman not supported. A
        regular decimal list marker is displayed instead </s:report>
      <s:report test="@css:list-style-type eq 'upper-roman'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0050</s:span> list-style-type:upper-roman not supported. A
        regular decimal list marker is displayed instead </s:report>
      <s:report test="@css:list-style-type eq 'lower-alpha'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0051</s:span> list-style-type:lower-alpha not supported. A
        regular decimal list marker is displayed instead </s:report>
      <s:report test="@css:list-style-type eq 'upper-alpha'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0052</s:span> list-style-type:upper-alpha not supported. A
        regular decimal list marker is displayed instead </s:report>
      <s:report test="@css:list-style-type eq 'lower-greek'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0053</s:span> list-style-type:lower-greek not supported. A
        regular decimal list marker is displayed instead </s:report>
      <s:report test="@css:list-style-type eq 'disc'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0054</s:span> list-style-type:disc is not required. A
        regular disc list marker is displayed per default </s:report>
      <s:report test="@css:list-style-type eq 'circle'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0055</s:span> list-style-type:circle not supported. A
        regular disc list marker is displayed instead </s:report>
      <s:report test="@css:list-style-type eq 'square'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0056</s:span> list-style-type:square not supported. A
        regular disc list marker is displayed instead </s:report>
      <s:report test="@css:list-style-type eq 'none'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0057</s:span> list-style-type:none not supported. A regular
        disc list marker is displayed instead </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-position]">
      <s:report test="@css:list-style-position eq 'inside'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0058</s:span> list-style-position:inside is not supported.
        The position of the list markers is always displayed outside the content flow </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-position]">
      <s:report test="@css:list-style-position eq 'outside'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0059</s:span> list-style-position:outside is not required.
        The position of the list markers is always displayed outside the content flow </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-image]">
      <s:report test="@css:list-style-image">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0060</s:span> list-style-image is not supported. A regular
        disc list marker is displayed instead </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * DISPLAY PROPTERTIES
       * -->
  <s:pattern id="display">
    <s:rule context="*[@css:display]">
      <s:report test="@css:display eq 'block'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0061</s:span> display:block is not supported. </s:report>
      <s:report test="@css:display eq 'inline'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0062</s:span> display:inline is not supported. </s:report>
      <s:report test="@css:display eq 'inline-block'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0063</s:span> display:inline-block is not supported. </s:report>
      <s:report test="@css:display eq 'none'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0064</s:span> display:none is not supported. </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * COLORS
       * -->
  <s:pattern id="color">
    <s:rule context="*[@css:color]">
      <s:report test="@css:color">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0065</s:span> color is not supported
      </s:report>
      </s:rule>
      <s:rule context="*[@css:background-color]">
      <s:report test="@css:background-color">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0070</s:span> background-color is not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
      * BACKGROUND STYLE
      * -->
  <s:pattern id="background">
    <s:rule context="*[@css:background-image]">
      <s:report test="@css:background-image">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0071</s:span> background-image is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:background-repeat]">
      <s:report test="@css:background-repeat">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0072</s:span> background-repeat is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:background-position]">
      <s:report test="@css:background-position">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0073</s:span> background-position is not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * DISPLAY PROPERTIES
       * -->
  <s:pattern id="visibility">
    <s:rule context="*[@css:clip]">
      <s:report test="@css:clip">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0074</s:span> clip is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:overflow]">
      <s:report test="@css:overflow">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0075</s:span> overflow is not supported. </s:report>
    </s:rule>
    <s:rule context="*[@css:visibility]">
      <s:report test="@css:visibility">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0076</s:span> visibility is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:direction]">
      <s:report test="@css:direction">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0077</s:span> direction is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:z-index]">
      <s:report test="@css:z-index">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0079</s:span> z-index is not supported </s:report>
    </s:rule>
  </s:pattern>
  <s:pattern id="width-height">
    <s:rule context="*[@css:width]">
      <s:report test="@css:width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0080</s:span> width is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:min-width]">
      <s:report test="@css:min-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0081</s:span> min-width is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:max-width]">
      <s:report test="@css:max-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0082</s:span> max-width is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:height]">
      <s:report test="@css:height">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0083</s:span> height is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:min-height]">
      <s:report test="@css:min-height">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0084</s:span> min-height is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:max-height]">
      <s:report test="@css:max-height">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0085</s:span> max-height is not supported </s:report>
    </s:rule>
  </s:pattern>
  <!-- *
       * TABLE STYLES
       * -->
  <s:pattern id="tables">
    <s:rule context="*[css:caption-side]">
      <s:report test="css:caption-side">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0086</s:span>caption-side is not supported </s:report>
    </s:rule>
    <s:rule context="*[css:table-layout]">
      <s:report test="css:table-layout">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0087</s:span>table-layout is not supported </s:report>
    </s:rule>
    <s:rule context="*[css:border-collapse]">
      <s:report test="css:border-collapse">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0088</s:span>border-collapse is not supported </s:report>
    </s:rule>
    <s:rule context="*[css:border-spacing]">
      <s:report test="css:border-spacing">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0089</s:span>border-spacing is not supported </s:report>
    </s:rule>
    <s:rule context="*[css:empty-cells]">
      <s:report test="css:empty-cells">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_Kindle_0090</s:span>empty-cells is not supported </s:report>
    </s:rule>
  </s:pattern>
</s:schema>
