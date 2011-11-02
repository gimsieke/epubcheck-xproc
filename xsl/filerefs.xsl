<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:epub="http://www.idpf.org/2007/ops" exclude-result-prefixes="xsl xs opf c dc"
    version="2.0">

    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

    <xsl:template match="/">
        <epub:report>
            <xsl:apply-templates/>
        </epub:report>
    </xsl:template>

    <xsl:template match="opf:metadata/descendant-or-self::*"/>

    <xsl:template match="opf:item">
        <xsl:variable name="opfFileRef" select="@href"/>
        <xsl:variable name="zipItems"
            select="(for $i in ancestor::epub/c:zipfile/c:file return replace($i/@name, 'OEBPS/', ''))"/>
        <xsl:variable name="nonMatchedItems" select="(for $i in $zipItems return $opfFileRef = $i)"/>
        <xsl:if test="every $i in $nonMatchedItems satisfies $i = false()">
            <epub:error href="{$opfFileRef}"/>
        </xsl:if>
        <xsl:variable name="MatchedItems"
            select="(every $i in $opfFileRef satisfies $zipItems = $i)"/>
        <xsl:if test="every $i in $MatchedItems satisfies $i = true()">
            <epub:correct href="{$opfFileRef}"/>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
