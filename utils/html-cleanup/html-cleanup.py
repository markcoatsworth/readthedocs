#!/usr/bin/env python

import bs4
import os
import re
import sys

def dump(obj):
    for attr in dir(obj):
        print("obj.%s = %r" % (attr, getattr(obj, attr)))


def main():

    # Command line arguments
    if len(sys.argv) < 2:
        print("Usage: html-cleanup.py <input-file>")
        sys.exit(1)
    
    # Open the input file
    filename = str(sys.argv[1])
    with open(filename, "r") as input_file:
        html_data = input_file.read()
    input_file.close()

    # Now start The Great HTML Parse!
    soup = bs4.BeautifulSoup(html_data, features="lxml")

    # Step 1: Delete things we don't want. Do this before editing any markup.

    # Delete the navigation tags (defined by <span style="font-size: 200%;>...</span>")
    nav_tags = soup.find_all("span", attrs={"style": "font-size: 200%;"})
    print("Found " + str(len(nav_tags)) + " navigation spans")
    for tag in nav_tags:
        tag.decompose()

    # Also delete the "Contents" and "Index" links
    links_tags = soup.find_all("a")
    for tag in links_tags:
        if tag.string:
            if tag.string == "Contents" or tag.string == "Index":
                tag.decompose()

    # Delete the table of contents
    toc_tags = soup.find_all("div", attrs={"class": "sectionTOCS"})
    for tag in toc_tags:
        tag.decompose()

    # Delete the section numbering
    titlemark_tags = soup.find_all("span", attrs={"class": "titlemark"})
    for tag in titlemark_tags:
        tag.decompose()

    # Convert all <span class="textbf">...</span> tags to <b>...</b>
    bold_tags = soup.find_all("span", attrs={"class": "textbf"})
    print("Found " + str(len(bold_tags)) + " textbf spans")
    for tag in bold_tags:
        new_tag = soup.new_tag("b")
        if tag.string:
            new_tag.string = tag.string
        tag.replace_with(new_tag)

    # Convert all <span class="textit">...</span> tags to <i>...</i>
    italic_tags = soup.find_all("span", attrs={"class": "textit"})
    print("Found " + str(len(italic_tags)) + " textit spans")
    for tag in italic_tags:
        new_tag = soup.new_tag("i")
        if tag.string:
            new_tag.string = tag.string
        tag.replace_with(new_tag)

    # Convert all <span class="texttt">...</span> tags to <code>...</code>
    code_tags = soup.find_all("span", attrs={"class": "texttt"})
    print("Found " + str(len(code_tags)) + " texttt spans")
    for tag in code_tags:
        new_tag = soup.new_tag("code")
        if tag.string:
            new_tag.string = tag.string
        tag.replace_with(new_tag)

    # Convert all <div class="verbatim">...</div> tags to <pre>...</pre>
    pre_tags = soup.find_all("div", attrs={"class": "verbatim"})
    print("Found " + str(len(pre_tags)) + " verbatim divs")
    for tag in pre_tags:
        new_tag = soup.new_tag("pre")
        new_tag.contents = tag.contents
        tag.replace_with(new_tag)


    # Overwrite the original file with the parseable markup
    output_file = open(filename + ".out", "w")
    output_file.write(str(soup))
    output_file.close()

if __name__ == "__main__":
    main()
