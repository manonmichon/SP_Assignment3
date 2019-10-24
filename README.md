# About this repository
This repository is part of an assignment for my course Scientific Programming in light of the master Systems Biology at Maastricht University. <br>
<br>
The aim of this repository is to find out the logP of smiles collected from wikidata. The smiles are obtained from wikidata using a SPARQL query. The downloaded tsv file is read into a nextflow script, which is then executed by calling it from the terminal.

# Files
_getSMILES.rq_: This file contains the SPARQL query used to obtain the list of smiles found in ‘query_medium.tsv’ and ‘query_long.tsv’.

_query_short.tsv_: A short tsv file containing 5 sets of a smile and a link to the wikidata page of the corresponding compound. Obtained from <a href="https://github.com/egonw/scientificProgramming/tree/master/assignment%203"> the github of this course</a>.

_query_medium.tsv_: A tsv file downloaded from wikidata using the query found in _getSMILES.rq_ with a limit of 1000 in order to test for file-input from wikidata and to test with a more varied dataset of smiles.

_query_long.tsv_: A tsv file downloaded from wikidata using the query found in _getSMILES.rq_ without a limit. This file contains 150,000 smiles and/or isosmiles.

_nextflowscript.nf_: The script executing the parallel computing.

# Using the Repository
_to be done_

# Expected Output
The nextflow script will calculate the logP values of all the smiles that are present in the input file (_query_long.tsv_). The verbose regarding the execution of the script will be printed into the terminal. The printing of the logP values themselves are muted, but can be done by uncommenting the line in the script. The errors surrounding the calculation of the logP will however be displayed. This occurs when the molecule of the given smile is not aromatised and doesn't contain explicit hydrogen atoms in the smile. The source code displaying this error can be found on <a href="https://github.com/cdk/cdk/blob/master/descriptor/qsarmolecular/src/main/java/org/openscience/cdk/qsar/descriptors/molecular/JPlogPDescriptor.java"> this page within the cdk github</a>.

# References & Licenses
<a href="https://github.com/manonmichon/SP_Assignment3/blob/master/LICENSE"> MIT license </a>
