<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:s="http://purl.oclc.org/dsdl/schematron">
  <!-- *
       * Schematron profile for iBooks on Apple iPad
       * 
       * 
       * -->

  <s:ns uri="http://www.w3.org/1996/css" prefix="css"/>

  <!-- *
       * FONTS 
       * -->
  <s:pattern id="font-family">
    <s:rule context="*[@css:font-family]">
      <s:report test="not (@css:font-family eq ( 'serif' or 
                                            'sans-serif' or 
                                            'cursive' or 
                                            'fantasy' or 
                                            'monospace' or 
                                            'baskerville' or 
                                            'cochin' or 
                                            'helvetica' or 
                                            'palatino' or 
                                            'times' or 
                                            'verdana' ))">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_iPad_0007</s:span> Apple iBooks for iPad supports per default generic fonts (serif, sans-serif, czrsive, fantasy and monospace) and the presinstalled fonts baskerville, cochin, helvetica, palatino, times and verdana  
      </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * TEXT STYLES
       * -->
  <s:pattern id="css-text">
    <s:rule context="*[@css:text-decoration]">
      <s:report test="@css:text-decoration eq 'blink'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0016</s:span> text-decoration:blink not supported
      </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * BORDER STYLES 
       * -->
  <s:pattern id="border-style">
    <s:rule context="*[@css:border-top-style]">
      <s:report test="@css:border-top-style eq (  'groove' or 
                                                  'ridge' or 
                                                  'inset' or 
                                                  'outset' )">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0027</s:span> only solid, dotted, dashed and double line styles are supported for border-top-style  </s:report>
    </s:rule>
    <s:rule context="*[@css:border-right-style]">
      <s:report test="@css:border-right-style  eq ( 'groove' or 
                                                    'ridge' or 
                                                    'inset' or 
                                                    'outset' )">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0028</s:span> only solid, dotted, dashed and double line styles are supported for border-right-style
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-bottom-style]">
      <s:report test="@css:border-bottom-style eq ( 'groove' or 
                                                    'ridge' or 
                                                    'inset' or 
                                                    'outset' )">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0029</s:span> only solid, dotted, dashed and double line styles are supported for border-bottom-style
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-left-style]">
      <s:report test="@css:border-left-style eq ( 'groove' or 
                                                  'ridge' or 
                                                  'inset' or 
                                                  'outset' )">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0030</s:span> only solid, dotted, dashed and double line styles are supported for border-left-style
      </s:report>
    </s:rule>
    <s:rule context="*[@css:border-style]">
      <s:report test="matches( @css:border-style, ( 'groove' or 
                                                    'ridge' or 
                                                    'inset' or 
                                                    'outset' ))">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0031</s:span> only solid, dotted, dashed and double line styles are supported for border
        Kindle DX. </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * DISPLAY PROPTERTIES
       * -->
  <s:pattern id="display">
    <s:rule context="*[@css:display]">
      <s:report test="@css:display eq 'inline-block'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0063</s:span> display:inline-block is not supported. </s:report>
    </s:rule>
  </s:pattern>
  <s:pattern id="visibility">
    <s:rule context="*[@css:overflow]">
      <s:report test="@css:overflow">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0075</s:span> overflow is not supported. </s:report>
    </s:rule>
  </s:pattern>
  <s:pattern id="width-height">
    <s:rule context="*[@css:max-width]">
      <s:report test="@css:max-width">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0082</s:span> max-width is not supported </s:report>
    </s:rule>
    <s:rule context="*[@css:max-height]">
      <s:report test="@css:max-height">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_iPad_0085</s:span> max-height is not supported </s:report>
    </s:rule>
  </s:pattern>
</s:schema>
