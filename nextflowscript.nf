#!/usr/bin/env nextflow //defining a scripting language

/** A channel will communicate between different processes. The channel here
* is created to communicate with the data file and the 'printSMILES' process
* in order for the 'printSMILES' process to access the data.
*
* fromPath: obtaining the desired data from a file using a file path.
* splitCsv: splitting the obtained data into different columns.
* map: a mapping function is applied to every channel output. Here a row is
*   formed by creating a tuple from the two elements found in the tsv-file.
* set: the tuple is denoted as a set. The set is referred to as "molecules_ch".
*/

Channel
    .fromPath("/Users/manonmichon/Documents/GitHub/SP_Assignment3/short.tsv")
    .splitCsv(header: ['wikidata', 'smiles'], sep:'\t')
    .map{ row -> tuple(row.wikidata, row.smiles) }
    .set { molecules_ch }

/** Prints the content of each set
*
* @param molecules_ch     The set containing the wikidata and smiles variables.
* @return                 A line will be printed, confirming the presence of
*                         data.

process printSMILES {
    input:
    set wikidata, smiles from molecules_ch

    exec:
      println "${wikidata} has SMILES: ${smiles}"
}
