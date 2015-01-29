#!/bin/bash

# test if i can get the version
VERSION=$(cat version)

#echo "Buildversion is "$VERSION""

#define the template.
cat > version.xml << EOF
<entry>
 <version>"$VERSION"</version>
 <url>http://docs.plone.org/Plone3.tgz</url>
</entry>
EOF
