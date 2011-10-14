<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:s="http://purl.oclc.org/dsdl/schematron"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:c="http://www.w3.org/ns/xproc-step"  
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0"
  exclude-result-prefixes="c html s svrl xs xsl"
  >

  <xsl:output method="xhtml" indent="yes" />

  <xsl:param name="schematron-content-links" as="xs:string" />

  <xsl:template name="main">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Report</title>
        <script language="JavaScript">
document.getElementsByClassName = function(class_name) {
    var docList = this.all || this.getElementsByTagName('*');
    var matchArray = new Array();

    /*Create a regular expression object for class*/
    var re = new RegExp("(?:^|\\s)"+class_name+"(?:\\s|$)");
    for (var i = 0; i != docList.length; i++) {
        if (re.test(docList[i].className) ) {
            matchArray[matchArray.length] = docList[i];
        }
    }

	return matchArray;
}

          function makeTransparent(msgid) {
            var list = document.getElementsByClassName(msgid);
            for (i = list.length - 1; i != 0; i--) {
              list[i].style.backgroundColor = "white";
            }
          }
        </script>
        <style type="text/css">
          p.schematron-report {
            margin:0;
            padding:0;
          }
          .ok-block {
            color: white;
            background-color: #0b0;
          }
          .err-block {
            color: white;
            background-color: red;
          }
          .wrn-block {
            background-color: yellow;
          }
          .hl {
          }
          .hl.wrn {
            background-color: #bb0;
          }
          .hl.err {
            background-color: #f66;
          }
          .non-content-heading {
            background-color:#666; 
            color:#fff; 
            font-family: sans-serif;
          }
        </style>
      </head>
      <body>
        <xsl:sequence select="collection()/*" />
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>