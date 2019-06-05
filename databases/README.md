The V gene protein sequences were combined from five sources:
 (1) Cirelli et al, Cell. 2019 May 16;177(5):1153-1171.e28.
 (2) Ramesh et al, Front Immunol. 2017; 8: 1407.
 (3) Corcoran et al, Nat Commun. 2016 Dec 20;7:13642. (subject 2635 Indian rhesus)
 (4) Sundling et al, Sci Transl Med. 2012 Jul 11;4(142):142ra96. (from ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/internal_data/rhesus_monkey/)
 (5) Lefranc, M.P. and Lefranc, G. The Immunoglobulin FactsBook Academic Press, London, UK (458 pages), (2001) (http://www.imgt.org/vquest/refseqh.html)

The nucleotide sequences of V genes were translated using the transeq tool in the EMBOSS 6.6.0.0 software suite [Rice et al, Trends in genetics 2000, 16:276-277] 
when the protein sequences were not directly available.
 
The sequences were aligned with muscle v3.8.1551 [Edgar R, Nucleic Acids Res. 2004; 32(5): 1792–1797].

Sequences that had missing amino acids or X were removed.

The corresponding nucleotide sequences of these complete V genes were clustered using CD-HIT v4.7 [Limin et al, Bioinformatics, 2012; 28:3150-3152] to remove 100% redundant sequences. 

The proteins sequences for this non-redundant set were submitted to DomainGapAlign tool [Ehrenmann F, Lefranc MP, Cold Spring Harb Protoc 2011, 2011:737-749] to get gapped sequences. Some gaps were edited manually.

Corresponding gaps were introduced in the non-redundant nucleotide sequences and the positions for the FR and CDR regions determined.

Since the gene names were inconsistent between different sources, new names for genes were assigned based on clustering at 95% identity using 
CD-HIT v4.7. The mapping to the original ids are listed in Map_newid_originalid.txt

The headers were modified to resemble IMGT headers. 

The gapped sequences required by MakeDb.py in the Immcantation pipeline are present in: 
  NHP_eOD-FTQ_manuscript/databases/fasta_immcantation/

The positions for the FR and CDR3 for IgBLAST are included in the 
  NHP_eOD-FTQ_manuscript/databases/igblast_files/internal_data/rhesus_monkey.ndm.imgt & 
  NHP_eOD-FTQ_manuscript/databases/igblast_files/internal_data/rhesus_monkey.pdm.imgt

The database sequences for IgBLAST are in: NHP_eOD-FTQ_manuscript/databases/igblast_files/internal_data/

The optional file for IgBLAST (ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/optional_file/): NHP_eOD-FTQ_manuscript/databases/igblast_files/optional_file/rhesus_monkey_gl.aux

The sequences for D and J gene segments were obtained from IMGT®* (http://www.imgt.org/vquest/refseqh.html)

-----------------------------------------------------------------------------------------------------------------------------------------
*Software material and data coming from IMGT server may be used for academic research only, provided that it is referred to IMGT®, and 
cited as "IMGT®, the international ImMunoGeneTics information system® http://www.imgt.org". For any other use please contact Marie-Paule 
Lefranc Marie-Paule.Lefranc@igh.cnrs.fr. For information on IMGT® copyright, warranty disclaimer, liability, endorsement, please see
http://www.imgt.org/about/warranty.php 
----------------------------------------------------------------------------------------------------------------------------------------- 