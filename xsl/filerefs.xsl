<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:c="http://www.w3.org/ns/xproc-step" exclude-result-prefixes="xs" version="2.0">

    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

    <xsl:template match="/">
        <check>
            <xsl:apply-templates/>
        </check>
    </xsl:template>
    
    <xsl:template match="opf:item">
        <xsl:variable name="opfFileRef" select="@href"/>
        <xsl:variable name="zipItems"
            select="(for $i in ancestor::global/c:zipfile/c:file return replace($i/@name, 'OEBPS/', ''))"/>
        <xsl:variable name="nonMatchedItems" select="(for $i in $zipItems return $opfFileRef = $i)"/>
        <xsl:if test="every $i in $nonMatchedItems satisfies $i = false()">
            <report>
                <xsl:attribute name="href" select="$opfFileRef"/>
            </report>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>