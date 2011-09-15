#!/bin/bash
java \
   -cp './resolver/resolver.jar;./resolver/;c:/Programme/calabash/calabash.jar;c:/Programme/calabash/lib' \
   -Dfile.encoding=UTF8 \
   -Dxml.catalog.files=resolver/catalog.xml \
   -Dxml.catalog.staticCatalog=1 \
   -Dxml.catalog.verbosity=9 \
   -Xmx1536m -Xss1024k \
   com.xmlcalabash.drivers.Main  \
   -E org.apache.xml.resolver.tools.CatalogResolver \
   -U org.apache.xml.resolver.tools.CatalogResolver \
   "$@"
