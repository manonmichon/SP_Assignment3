#!/usr/bin/env nextflow

Channel
    .fromPath("/Users/manonmichon/Documents/GitHub/SP_Assignment3/short.tsv")
    .splitCsv(header: ['wikidata', 'smiles'], sep:'\t')
    .map{ row -> tuple(row.wikidata, row.smiles) }
    .set { molecules_ch }

process printSMILES {
    input:
    set wikidata, smiles from molecules_ch

    exec:
      println "${wikidata} has SMILES: ${smiles}"
}
