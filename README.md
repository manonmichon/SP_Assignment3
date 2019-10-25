# About this repository
This repository is part of an assignment for the course Scientific Programming in light of the master Systems Biology at Maastricht University. <br>
<br>
The aim of this repository is to find out the logP of smiles collected from wikidata and to monitor the effects of parallel computing while doing so. The smiles are obtained from wikidata using a SPARQL query. The downloaded tsv file is read into a nextflow script, which is then executed by calling it from the terminal. The calculations in the script are done by parallel computing.

# Files
_getSMILES.rq_: This file contains the SPARQL query used to obtain the list of smiles found in ‘query_medium.tsv’ and ‘query_long.tsv’.

_query_short.tsv_: A short tsv file containing 5 sets of a smile and a link to the wikidata page of the corresponding smile. Obtained from <a href="https://github.com/egonw/scientificProgramming/tree/master/assignment%203"> the github of this course</a>.

_query_medium.tsv_: A tsv file downloaded from wikidata using the query found in _getSMILES.rq_ with a limit of 1000 in order to test for file-input from wikidata and to test with a more varied dataset of smiles.

_query_long.tsv_: A tsv file downloaded from wikidata using the query found in _getSMILES.rq_ without a limit. This file contains about 150,000 smiles and/or isosmiles.

_nextflowscript.nf_: The script calculating the logP and executing the parallel computing.

# Using the Repository
The scrip _nextflowscript.nf_ can be run with nextflow. Nextflow can be used on any POSIX compatible system such as Linux and OS X. More information on downloading and using nextflow can be found on <a href="https://www.nextflow.io/">the nextflow website</a>. For people with a windows environment it is recommended to use <a href="https://www.docker.com/">Docker</a> in order to run nextflow.<br>
<b>Before running the script</b> change the file path in the script the file path on your computer. Furthermore, change the buffer size to the required size. Changing the buffer size will simulate the usage of the CPU. By chuncking all data together into one buffer-set, only one CPU will be used. By changing the buffer size to half of the total size of the data, two CPU's will be used. The same goes for the usage of four CPU's with chuncking the data into four buffer-sets.<br>
Running the script as is in the repository will only give the logp of the smiles that are present at the time that the query was requested in creating the _query_long.tsv_ file. For a more updated version of this file, enter the query found in _getSMILES.rq_ in <a href="https://query.wikidata.org/">https://query.wikidata.org/</a>. The results can be downloaded as .tsv file. Remove the headers in the file and change the path in the script to where you saved the file.

# Expected Output
The nextflow script will calculate the logP values of all the smiles that are present in the input file (_query_long.tsv_). The verbose regarding the execution of the script will be printed into the terminal. The printing of the logP values themselves are muted, but can be done by uncommenting the line in the script. The errors surrounding the calculation of the logP will however be displayed. This occurs when the molecule of the given smile is not aromatised and doesn't contain explicit hydrogen atoms in the smile. The source code displaying this error can be found on <a href="https://github.com/cdk/cdk/blob/master/descriptor/qsarmolecular/src/main/java/org/openscience/cdk/qsar/descriptors/molecular/JPlogPDescriptor.java"> this page within the cdk github</a>. Since the aim is to investigate parallel computing and the other logP values can succesfully be printed, these errors are no problem.

# References & Licenses
<a href="https://github.com/manonmichon/SP_Assignment3/blob/master/LICENSE"> MIT license </a><br>
Bioclipse, containing the CDK manager <a href="https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-10-397">article</a>/<a href="https://github.com/egonw/bacting">Bacting github</a>/<a href="https://github.com/cdk/cdk">CDK github</a>.<br>
LogP calculation: <a href="https://link.springer.com/article/10.1186/s13321-018-0316-5">article</a>/<a href="https://github.com/cdk/cdk/blob/master/descriptor/qsarmolecular/src/main/java/org/openscience/cdk/qsar/descriptors/molecular/JPlogPDescriptor.java">github</a>.
