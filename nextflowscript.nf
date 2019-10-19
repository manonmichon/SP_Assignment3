#!/usr/bin/env nextflow //defining a scripting language

// initialisation of required packages and package sources.
@Grab(group='io.github.egonw.bacting', module='managers-cdk', version='0.0.9')
import net.bioclipse.managers.CDKManager

/** A channel will communicate between different processes. The channel here
* is created to communicate with the data file and the 'obtainlogp' process
* in order for the 'obtainlogp' process to access the data.
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

/** Prints the chemical formula of each smile, obtained from the CDK manager.
* cdk:             Calls the Chemistry Development Kit (CDK) manager from the
*                  bacting github.
* ChemicalFormula: cdk.fromSMILES converts the smiles into the chemical
*                  formula.
*
* @param molecules_ch     The set containing the wikidata and smiles variables.
* @return                 A line will be printed, confirming the conversion of
                          the smiles into the chemical formula
*/

process obtainlogp {
    input:
    set wikidata, smiles from molecules_ch

    exec:
      cdk = new CDKManager(".");
      ChemicalFormula = cdk.fromSMILES("$smiles")
      println "${ChemicalFormula}"
}
