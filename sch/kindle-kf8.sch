<?xml version="1.0" encoding="UTF-8"?>
<s:schema
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:s="http://purl.oclc.org/dsdl/schematron"
  >
  <!-- *
       * Preliminary Schematron profile for the upcoming Kindle Format 8
       * 
       * Note: This profile could not be tested yet and will be object to distinct changes. It applies to the short reference published by Amazon: http://www.amazon.com/gp/feature.html/ref=amb_link_357613442_1?ie=UTF8&docId=1000729901&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-5&pf_rd_r=1A2017EDG09MYRRG7GA3&pf_rd_t=1401&pf_rd_p=1321300302&pf_rd_i=1000729511  
       * -->

  <s:ns uri="http://www.w3.org/1996/css" prefix="css"/>

  <s:pattern id="css-position">
    <s:rule context="*[@css:position]">
      <s:report test="@css:position eq 'fixed'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_KindleKF8_0001</s:span>
        position:fixed not supported
      </s:report>
      <s:report test="@css:position eq 'absolute'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_KindleKF8_0002</s:span>
        position:absolute not supported
      </s:report>
      <s:report test="@css:position eq 'relative'">
        <s:span class="severity">ERR</s:span>
        <s:span class="msgid">SCH_KindleKF8_0003</s:span>
        position:relative not supported
      </s:report>
    </s:rule>
  </s:pattern>

  <!-- *
       * SPACING
       * -->
  <s:pattern id="spacing">
    <s:rule context="*[@css:line-height]">
      <s:report test="@css:line-height">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0004</s:span>
        line-height not supported
      </s:report>
    </s:rule>
  </s:pattern>
  <!--  *
        * lists
        * -->
  <s:pattern id="list-style-type">
    <s:rule context="*[@css:list-style-type]">
      <s:report test="@css:list-style-type eq 'decimal'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0005</s:span>
        list-style-type:decimal is not required. A regular decimal list marker is displayed per default
      </s:report>
      <s:report test="@css:list-style-type eq 'lower-roman'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0006</s:span>
        list-style-type:lower-roman not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'upper-roman'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0007</s:span>
        list-style-type:upper-roman not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'lower-alpha'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0008</s:span>
        list-style-type:lower-alpha not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'upper-alpha'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0009</s:span>
        list-style-type:upper-alpha not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'lower-greek'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0010</s:span>
        list-style-type:lower-greek not supported. A regular decimal list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'disc'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0011</s:span>
        list-style-type:disc is not required. A regular disc list marker is displayed per default
      </s:report>
      <s:report test="@css:list-style-type eq 'circle'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0012</s:span>
        list-style-type:circle not supported. A regular disc list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'square'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0013</s:span>
        list-style-type:square not supported. A regular disc list marker is displayed instead
      </s:report>
      <s:report test="@css:list-style-type eq 'none'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0014</s:span>
        list-style-type:none not supported. A regular disc list marker is displayed instead
      </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-position]">
      <s:report test="@css:list-style-position eq 'inside'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0015</s:span>
        list-style-position:inside is not supported. The position of the list markers is always displayed outside the content flow
      </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-position]">
      <s:report test="@css:list-style-position eq 'outside'">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0016</s:span>
        list-style-position:outside is not required. The position of the list markers is always displayed outside the content flow
      </s:report>
    </s:rule>
    <s:rule context="*[@css:list-style-image]">
      <s:report test="@css:list-style-image">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0017</s:span>
        list-style-image is not supported. A regular disc list marker is displayed instead
      </s:report>
    </s:rule>
  </s:pattern>
 <!-- *
      * Background styles
      * -->
  <s:pattern id="background">
    <s:rule context="*[@css:background-image]">
      <s:report test="@css:background-image">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0018</s:span>
          background-image is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:background-repeat]">
      <s:report test="@css:background-repeat">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0019</s:span>
        background-repeat is not supported
      </s:report>
    </s:rule>
    <s:rule context="*[@css:background-position]">
      <s:report test="@css:background-position">
        <s:span class="severity">WRN</s:span>
        <s:span class="msgid">SCH_KindleKF8_0020</s:span>
        background-position is not supported
      </s:report>
    </s:rule>
  </s:pattern>
</s:schema>