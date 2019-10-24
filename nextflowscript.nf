#!/usr/bin/env nextflow //defining the scripting language

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
* formed by creating a tuple from the three elements found in the tsv-file.
* buffer: multiple tuples are bound together.
* set: the whole output of the channel is denoted as "molecules_ch".
*/

Channel
    .fromPath("./GitHub/SP_Assignment3/query_long.tsv") //change path to math file path
    .splitCsv(header: ['wikidata', 'smiles', 'isosmiles'], sep:'\t')
    .map{ row -> tuple(row.wikidata, row.smiles, row.isosmiles) }
    .buffer( size: 150000, remainder: true) //change buffer size to desired size
    .set { molecules_ch }

/** calculates the logP for each compound obtained on wikidata.
* for-loop:        A for-loop is used to loop over all the elements in 'rowChuncks'
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
* @param molecules_ch     The complete output of the channel
* @param rowChuncks       The buffer-set containing multiple sets 'rowChuncks'
* @param row              Each individual set containing the link of the wikidata-
*                         page of each smile, the smile, and the isosmile.
* @return                 The logp will be calculated
*/

process obtainlogp {
    maxForks 1 // The maximum amount of forks the process is allowed to create

    input:
    each rowChuncks from molecules_ch

    exec:

    cdk = new CDKManager(".")
    descriptor = new JPlogPDescriptor()
    for (row in rowChuncks){
      smile = row[1]
      ChemicalFormula = cdk.fromSMILES("$smile")
      logp = descriptor.calculate(ChemicalFormula.getAtomContainer()).value.doubleValue()
      //To reduce the amount of output, this line is commented out, uncomment to
      //see the p-values of each smile
      //println "$smile has a logP value of $logp"
    }
}
