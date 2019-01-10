#!/usr/bin/env python

import os
import re
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: html-cleanup.py <input-file>")
        sys.exit(1)
    
    # Open the input file
    filename = str(sys.argv[1])
    with open(filename, "r") as input_file:
        html_data = input_file.read()
    input_file.close()

    # Testing
    #html_data = """ """

    # Test patterns
    #all_matches = re.findall(r'<span style="font-size: 200%;">([\w\s="<>&#;/\.]*)</span>', html_data)
    #all_matches = re.findall(r'<div class="verbatim" id="[\w\s-]*">([\w\s\-\.\(\)\'\\="<>!@#$%^&*:;,/|]*)</div>', html_data)
    #print("Number of matches: " + str(len(all_matches)))

    # Rip out header and footer navigations
    html_data = re.sub(r'<span style="font-size: 200%;">([([\w\s="<>&#;/\.]*)</span>', r'', html_data)
    html_data = re.sub(r'<a href="contentsname.html">Contents</a>&nbsp;<a href="indexname.html">Index</a>', r'', html_data)
    
    # Replace generated HTML with native tags
    html_data = re.sub(r'<span class="textbf"><span class="textit"([\w\s\-&#_]*)</span></span>', r'<b><i>\1</i></b>', html_data)
    html_data = re.sub(r'<span class="textbf">([\w\s\-&#_]*)</span>', r'<b>\1</b>', html_data)
    html_data = re.sub(r'<span class="textit">([\w\s\-&#_]*)</span>', r'<i>\1</i>', html_data)
    html_data = re.sub(r'<span class="texttt">([\w\s\-&#_]*)</span>', r'<code>\1</code>', html_data)
    html_data = re.sub(r'<span class="emph">([\w\s\-&#_]*)</span>', r'<b>\1</b>', html_data)
    html_data = re.sub(r'<div class="verbatim" id="[\w\s-]*">([\w\s\-\.\(\)\'\\="<>#$&*:;,/|]*)</div>', r'<pre>\1</pre>', html_data)
    print(html_data)

    # Overwrite the original file with the parseable markup
    output_file = open(filename + ".out", "w")
    output_file.write(html_data)
    output_file.close()

if __name__ == "__main__":
    main()
