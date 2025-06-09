#!/bin/sh
#
# Copyright 2025 Martin Goellnitz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Create the flavour of the READM.md here to be used for docker hub.
#
cp README.md README-hub.md
for src in $(grep ']: htt' README.md|sed -e 's/]:.http/_http/g') ; do
  URL=$(echo $src|cut -d '_' -f 2|sed -e 's/\//\\\//g')
  TAG=$(echo $src|cut -d '_' -f 1|cut -d '[' -f 2)
  # echo $TAG: $URL
  sed -i.sed -e "s/\]\[$TAG\]/]($URL)/g" README-hub.md
done
mv README-hub.md README-hub.md.sed
grep -v ']: htt' README-hub.md.sed > README-hub.md
rm -f README-hub.md.sed
