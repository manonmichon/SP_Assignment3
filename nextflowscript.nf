#!/usr/bin/env nextflow //defining a scripting language

// Path in terminal: time /Users/manonmichon/nextflow run /Users/manonmichon/Documents/GitHub/SP_Assignment3/nextflowscript.nf

// initialisation of required packages and package sources.
@Grab(group='io.github.egonw.bacting', module='managers-cdk', version='0.0.9')
@Grab(group='org.openscience.cdk', module='cdk-qsarmolecular', version='2.3')

import net.bioclipse.managers.CDKManager
import org.openscience.cdk.interfaces.IAtomContainer
import org.openscience.cdk.*;
import org.openscience.cdk.templates.*;
import org.openscience.cdk.tools.*;
import org.openscience.cdk.tools.manipulator.*;
import org.openscience.cdk.qsar.descriptors.molecular.JPlogPDescriptor;
import org.openscience.cdk.qsar.result.*;

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
    .fromPath("/Users/manonmichon/Documents/GitHub/SP_Assignment3/query_medium.tsv")
    .splitCsv(header: ['wikidata', 'smiles', 'isoSmiles'], sep:'\t')
    .map{ row -> tuple(row.wikidata, row.smiles, row.isosmiles) }
    .set { molecules_ch }

/** calculates the logP for each compound obtained on wikidata.
* cdk:             Calls the Chemistry Development Kit (CDK) manager from the
*                  bacting github.
* ChemicalFormula: cdk.fromSMILES converts the smiles into the chemical
*                  formula.
* descriptor:      This class from the CDK manager will enable calculation of
*                  the logP of each compound obtained from wikidata
* logp:            The logp of each compound is calculated using the logp
*                  class from the CDK manager as described above as well as the
*                  IAtomContainer, which will convert the chemical formula into
*                  an atom container.
*
* @param molecules_ch     The set containing the wikidata and smiles variables.
* @return                 A line will be printed, confirming the conversion of
                          the smiles into the chemical formula
*/

process obtainlogp {
    maxForks 1

    input:
    set wikidata, smiles, isosmiles from molecules_ch

    exec:
      cdk = new CDKManager(".");
      ChemicalFormula = cdk.fromSMILES("$smiles")

      descriptor = new JPlogPDescriptor()
      logp = descriptor.calculate(ChemicalFormula.getAtomContainer()).value.doubleValue()

}
