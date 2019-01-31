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
        print("Usage: html-cleanup.py <input-file> [Optional]: <output-file>")
        sys.exit(1)
    
    # Open the input file
    input_filename = str(sys.argv[1])
    with open(input_filename, "r") as input_file:
        html_data = input_file.read()
    input_file.close()

    # Check if output file was specified, if so record it
    output_filename = input_filename + ".out"
    if len(sys.argv) >= 3:
        output_filename = str(sys.argv[2])

    # Now start The Great HTML Parse!
    print("Cleaning up " + input_filename + " to " + output_filename)
    soup = bs4.BeautifulSoup(html_data, features="lxml")

    # STEP 1
    # Delete things we don't want. Do this before editing any markup.

    # Delete the navigation tags (defined by <span style="font-size: 200%;>...</span>")
    nav_tags = soup.find_all("span", attrs={"style": "font-size: 200%;"})
    #print("Found " + str(len(nav_tags)) + " navigation spans")
    for tag in nav_tags:
        tag.decompose()

    # Delete the "Contents" and "Index" links. Also delete all empty links.
    links_tags = soup.find_all("a")
    for tag in links_tags:
        if tag.string:
            if tag.string == "Contents" or tag.string == "Index":
                tag.decompose()
        else:
            # We don't want to delete links that have an href set
            if "href" not in tag.attrs:
                tag.decompose()

    # Delete the table of contents
    toc_tags = soup.find_all("div", attrs={"class": "sectionTOCS"})
    for tag in toc_tags:
        tag.decompose()

    # Delete the section numbering
    titlemark_tags = soup.find_all("span", attrs={"class": "titlemark"})
    for tag in titlemark_tags:
        tag.decompose()

    # At this point, soup is sufficiently confused that we should reload the contents of our HTML markup
    html_dump = str(soup)
    soup = bs4.BeautifulSoup(html_dump, features="lxml")

    # STEP 2
    # Now manipulate the elements we want to keep

    # Convert all <span class="textbf">...</span> tags to <b>...</b>
    bold_tags = soup.find_all("span", attrs={"class": "textbf"})
    #print("Found " + str(len(bold_tags)) + " textbf spans")
    for tag in bold_tags:
        new_tag = soup.new_tag("b")
        if tag.string:
            new_tag.string = tag.string
        tag.replace_with(new_tag)

    # Convert all <span class="textit">...</span> tags to <i>...</i>
    italic_tags = soup.find_all("span", attrs={"class": "textit"})
    #print("Found " + str(len(italic_tags)) + " textit spans")
    for tag in italic_tags:
        new_tag = soup.new_tag("i")
        if tag.string:
            new_tag.string = tag.string
        #print("new_tag = " + str(new_tag))
        #print("new_tag.parent" + str(new_tag.parent))
        tag.replace_with(new_tag)

    # Convert all <span class="texttt">...</span> tags to <code>...</code>
    """
    code_tags = soup.find_all("span", attrs={"class": "texttt"})
    print("Found " + str(len(code_tags)) + " texttt spans")
    for tag in code_tags:
        new_tag = soup.new_tag("code")
        if tag.string:
            new_tag.string = tag.string
        tag.replace_with(new_tag)
    """

    # Convert all <h3> tags to <h1>
    h3_tags = soup.find_all("h3")
    #print("Found " + str(len(h3_tags)) + " h3 tags")
    for tag in h3_tags:
        #print("tag = " + str(tag))
        new_tag = soup.new_tag("h1")
        if tag.string:
            #print("tag.string = " + tag.string)
            new_tag.string = tag.string
        tag.replace_with(new_tag)
    """
    # Convert all <h4> tags to <h2>
    h4_tags = soup.find_all("h4")
    #print("Found " + str(len(h4_tags)) + " h4 tags")
    for tag in h4_tags:
        #print("tag = " + str(tag))
        new_tag = soup.new_tag("h2")
        if tag.string:
            new_tag.string = tag.string
        tag.replace_with(new_tag)

    # Convert all <h5> tags to <h3>
    h5_tags = soup.find_all("h5")
    #print("Found " + str(len(h5_tags)) + " h4 tags")
    for tag in h4_tags:
        #print("tag = " + str(tag))
        new_tag = soup.new_tag("h3")
        if tag.string:
            new_tag.string = tag.string
        tag.replace_with(new_tag)
    """

    # TODO: For some reason this block of code screws up future parsing.
    # For now put it last. Later, figure out what is breaking.
    # Convert all <div class="verbatim">...</div> tags to <pre>...</pre>
    pre_tags = soup.find_all("div", attrs={"class": "verbatim"})
    #print("Found " + str(len(pre_tags)) + " verbatim divs")
    for tag in pre_tags:
        new_tag = soup.new_tag("pre")
        new_tag.contents = tag.contents
        tag.replace_with(new_tag)

    #pretty_html = soup.prettify().encode('utf-8')
    #print(pretty_html)


    # Overwrite the original file with the parseable markup
    output_file = open(output_filename, "w")
    output_file.write(str(soup))
    output_file.close()

if __name__ == "__main__":
    main()
