#!/bin/bash

echo "html-cleanup"
for filename in ./src/*; do
	./html-cleanup.py $filename
done

printf "End of file\n"
	
#pandoc -f html -t rst dst/users-manual/submit.html > ../../docs/users-manual/submit.rst
