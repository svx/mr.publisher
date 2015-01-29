#!/bin/bash

# test if i can get the version
VERSION=$(cat version.txt)

#echo "Buildversion is "$VERSION""

#define the template.
cat > Plone4/version.xml << EOF
<entry>
 <version>"$VERSION"</version>
 <url>http://docs.plone.org/Plone4.tgz</url>
</entry>
EOF
