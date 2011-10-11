#!/bin/bash
cygwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true;
esac

CLASSPATH='./resolver/resolver.jar:./resolver/:./calabash/calabash.jar:./calabash/lib'

if $cygwin; then
  CLASSPATH=`cygpath --path -w $CLASSPATH`
fi

java \
   -cp $CLASSPATH \
   -Dfile.encoding=UTF8 \
   -Dxml.catalog.files=resolver/catalog.xml \
   -Dxml.catalog.staticCatalog=1 \
   -Dxml.catalog.verbosity=9 \
   -Xmx1536m -Xss1024k \
   com.xmlcalabash.drivers.Main  \
   -E org.apache.xml.resolver.tools.CatalogResolver \
   -U org.apache.xml.resolver.tools.CatalogResolver \
   "$@"
