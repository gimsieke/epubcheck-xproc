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
        <xsl:variable name="correctFileRefs" as="xs:string">
            <xsl:for-each select=".">
                <xsl:variable name="opfFileRef" select="@href"/>
                <xsl:for-each select="ancestor::global/c:zipfile/c:file">
                    <xsl:variable name="epubFileRef" select="substring-after(@name, 'OEBPS/')"/>
                    <xsl:if test="normalize-space($opfFileRef) = normalize-space($epubFileRef)">
                        <xsl:sequence select="$opfFileRef"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:message select="$correctFileRefs"/>
    </xsl:template>

    


</xsl:stylesheet>
