<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/" />
  <sch:ns prefix="opf" uri="http://www.idpf.org/2007/opf" />
  
  
  <sch:pattern id="opf_idAttrUnique">
    <!-- id attribute value must be unique for any id attribute in opf file-->
    <sch:rule context="//*[@id]">
      <sch:assert test="count(//@id[. = current()/@id]) = 1"> 
        The "id" attribute does not have a unique value! 
      </sch:assert> 
    </sch:rule>
  </sch:pattern>
  
  <!-- Custom Rules -->
  
  <!-- Are the attributes of <item> present?, Martin Kraetke, 6.8.2011 -->
  <sch:pattern  id="opf_itemAttributesPresent">
    <sch:rule context="//opf:item">
      <sch:assert test="@id">Element 'item' contains no Attribute 'id'</sch:assert> 
      <sch:assert test="@href">Element 'item' contains no Attribute 'href'</sch:assert>
      <sch:assert test="@media-type">Element 'item' contains no Attribute 'media-type'</sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <!-- An metadata element is empty?, Martin Kraetke, 6.8.2011 -->
  <sch:pattern id="opf_metadataEmpty">
    <sch:rule context="opf:metadata/*"> 
      <sch:assert test="normalize-space(.)">A metadata element does not contain any text</sch:assert> 
    </sch:rule>
  </sch:pattern>
  
  <!-- Spine got no child elements?, Martin Kraetke, 6.8.2011 -->
  <sch:pattern  id="opf_spineChildren">
    <sch:rule context="opf:spine"> 
      <sch:assert test="*">Element 'spine' does not contain any child element</sch:assert> 
    </sch:rule>
  </sch:pattern>
  
  <!-- Dublin Core Language Check, Martin Kraetke, 6.8.2011 -->
  <sch:pattern  id="dc_langTest"> 
    <sch:rule context="dc:language"> 
      <sch:report test="contains(.,'de-DE')">Language is de-DE</sch:report> 
      <sch:report test="contains(.,'en-US')">Language is en-US</sch:report>
    </sch:rule> 
  </sch:pattern>
  
  
  
</sch:schema>