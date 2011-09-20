<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xslout="bogo"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:letex="http://www.le-tex.de/namespace"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:css="http://www.w3.org/1996/css"
  xpath-default-namespace="http://www.w3.org/1996/css"
  >
  
  <xsl:import href="css-util.xsl"/>

  <xsl:namespace-alias stylesheet-prefix="xslout" result-prefix="xsl"/>

	<xsl:output indent="yes" />

  <xsl:template match="/">
		<xsl:apply-templates mode="create-xsl" />
	</xsl:template>

	<xsl:template match="css" mode="create-xsl">
		<xslout:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:letex="http://www.le-tex.de/namespace" xmlns:css="http://www.w3.org/1996/css">
      <xsl:sequence select="document('css-util.xsl')/*/node()" />
			<xslout:template match="/">
				<xslout:variable name="add-css-info">
					<xslout:apply-templates mode="add-css-info" />
				</xslout:variable>
				<xslout:variable name="add-style-info">
					<xslout:apply-templates select="$add-css-info" mode="add-style-info" />
				</xslout:variable>
				<xslout:apply-templates select="$add-style-info" mode="handle-important-info" />
			</xslout:template>

			<xsl:for-each select="ruleset[declaration]/selector">
				<xsl:variable name="current-node" select="." />
				<xsl:variable name="class-attribute" select="if (matches(., '@class')) then replace(replace(., '.+?(\[matches\(@class,.\(\^\|\\s\)(.+?)\(\\s\|\$\))?', '$2 '), '\s+', ' ') else ''" />
				<xsl:variable name="leading-zero" select="if (string-length(@position) eq 1) then '000' else 
																									if (string-length(@position) eq 2) then '00' else 
																									if (string-length(@position) eq 3) then '0' else ''" />
        <xslout:template match="{if (not(starts-with(., '*'))) then '*:' else ''}{.}" priority="{number(concat(replace(@priority, ',', ''), '.', $leading-zero, @position))}" mode="add-css-info">
					<xslout:param name="last-pos" tunnel="yes">0</xslout:param>
					<xslout:variable name="class" select="'{normalize-space($class-attribute)}'" />
					<xslout:variable name="pos" select="index-of(tokenize(@class, ' '), $class)" />
					<xslout:copy>
						<xslout:apply-templates select="@*" mode="#current" />
						
						<xsl:for-each select="../declaration">
							<xslout:attribute name="{concat(@property, if (@important='yes') then '_important' else '')}" select="'{replace(@value, &#x22;'&#x22;, '&#x22;')}'" namespace="http://www.w3.org/1996/css" />
						</xsl:for-each>
						<xslout:variable name="more-attributes">
							<xslout:next-match>
								<xslout:with-param name="last-pos" select="$pos" />
							</xslout:next-match>
						</xslout:variable>
						<xslout:copy-of select="$more-attributes/*[1]/@*[not(contains('{for $i in $current-node/../declaration/@property return concat($i, if ($i/parent::*/@important='yes') then '_important' else '')}', local-name()))]" />
						<xslout:apply-templates select="node()" mode="#current" />
					</xslout:copy>
        </xslout:template>
      </xsl:for-each>

			<xslout:template match="*[@style]" mode="add-style-info">
				<xslout:variable name="style-info" as="element(css:declaration)*">
					<xslout:call-template name="declarations">
						<xslout:with-param name="raw-declarations" select="@style" />
					</xslout:call-template>
				</xslout:variable>
				<xslout:copy>
					<xslout:apply-templates select="@*" mode="#current" />
					<xslout:for-each select="$style-info/self::css:declaration">
						<xslout:attribute name="{{concat(@property, if (@important='yes') then '_important' else '')}}" select="@value" namespace="http://www.w3.org/1996/css" />
					</xslout:for-each>
					<xslout:apply-templates select="node()" mode="#current" />
				</xslout:copy>
			</xslout:template>

			<xslout:template match="*" priority="-1000" mode="#all">
				<xslout:copy>
          <xslout:namespace name="css">http://www.w3.org/1996/css</xslout:namespace>
					<xslout:apply-templates select="@* | node()" mode="#current" />
				</xslout:copy>
			</xslout:template>
			<xslout:template match="attribute() | text() | processing-instruction() | comment()" priority="-95" mode="#all">
				<xslout:copy>
					<xslout:apply-templates select="@* | node()" mode="#current" />
				</xslout:copy>
			</xslout:template>


			<xslout:template match="*[@*[matches(name(), '_important$')]]" mode="handle-important-info">
				<xslout:variable name="important-props">
					<xslout:for-each select="@*[matches(name(), '_important$')]">
						<xslout:element name="{{replace(name(), '^(.*)_important$', '$1')}}">
							<xslout:attribute name="val" select="." />
						</xslout:element>
					</xslout:for-each>
				</xslout:variable>
				<xslout:copy>
					<xslout:apply-templates select="@* except @*[contains(string-join($important-props/*/name(), ' '), name())]" mode="#current" />
					<xslout:apply-templates select="node()" mode="#current" />
				</xslout:copy>
			</xslout:template>

			<xslout:template match="@*[matches(name(), '_important$')]" mode="handle-important-info">
				<xslout:attribute name="{{replace(name(), '^(.*)_important$', '$1')}}" select="." />
			</xslout:template>


		</xslout:stylesheet>
	</xsl:template>


</xsl:stylesheet>