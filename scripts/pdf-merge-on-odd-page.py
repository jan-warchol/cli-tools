#!/usr/bin/env python

# requires PyPdf library, version 1.13 or above -
# its homepage is http://pybrary.net/pyPdf/
# runing: ./this-script-name file-with-pdf-list > output.pdf

import copy, sys
from pyPdf import PdfFileWriter, PdfFileReader
output = PdfFileWriter()
output_page_number = 0

# every new file should start on (n*alignment + 1)th page
# (with value 2 this means starting always on an odd page)
alignment = 2

listoffiles = open(sys.argv[1]).read().splitlines()
for filename in listoffiles:
    # This code is executed for every file in turn
    input = PdfFileReader(open(filename))
    for p in [input.getPage(i) for i in range(0,input.getNumPages())]:
        # This code is executed for every input page in turn
        output.addPage(p)
        output_page_number += 1
    while output_page_number % alignment != 0:
        output.addBlankPage()
        output_page_number += 1
output.write(sys.stdout)
