#!/bin/bash

cd src
for HtmlCleanupFilename in *.html; do
	../html-cleanup.py $HtmlCleanupFilename ../dst/$HtmlCleanupFilename.out
done
cd ..

#cd dst
#for InputHtmlFilename in *.html.out do
#	pandoc -f html -t rst $InputHtmlFilename > ../../docs/$InputHtmlFilename.rst
#done
#cd ..

#pandoc -f html -t rst dst/users-manual/submit.html > ../../docs/users-manual/submit.rst
