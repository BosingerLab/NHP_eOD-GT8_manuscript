**AIRR-Seq analysis**

1. The samples were sequenced three times on Illumina MiSeq. A technical replicate was also performed for RQi15 and 20_12. 
   Technical replicates were not successful for RAp15 and 163_12 due to the low cell number.

2. The samples were first demutiplexed using the Illumina bcl2fastq tools using

   `bcl2fastq --sample-sheet samplesheet.csv -o Unaligned --barcode-mismatches 0`
   
2. FastQC v0.11.5 [1] was used to check the quality of the fastq files.
 
3. pRESTO v 0.5.3 [2] used for pre-processing.

3. Assemble: Reads assembled using AssemblePairs.py
   
   `AssemblePairs.py align -1 <Read1.fastq> -2 <Read2.fastq> --coord illumina --nproc 2 --rc tail --outname <output> --log <log file>`
   
   GNU parallel [3] was used to process multiple samples simultaneously.
  
4. After assembly, the files from all three sequencing runs were combined.
  
5. The run_extraction2.pl and extract_inline2.pl scripts were used to demultiplex samples.

6. Filter: Reads mean quality score of less than 20 filtered using FilterSeq.py

   `FilterSeq.py quality -s <input> -q 20 --outname <output> --log <log file>`

7. Mask primers: MaskPrimers tool used to remove the forward primers and the random nucleotides from the assembled sequences

   `MaskPrimers.py score -s <input> -p <primer.fasta> --start <start> --mode cut --outname <output> --log <log file>`

8. Parse headers

   `ParseHeaders.py expand -s <input> -f PRIMER`

9. Parse headers

    `ParseHeaders.py rename -s <input> -f PRIMER1 -k VPRIMER --outname <out>`
   
10. Concatenated technical replicates for RQi15 and 20_12.

11. Remove duplicates and get DUPCOUNT for each unique sequence using CollapseSeq

    `CollapseSeq.py -s <input> -n 20 --inner --cf VPRIMER --act set --outname <output> --log <log file>`

12. Filter sequences with DUPCOUNT < 2: SplitSeq

    `SplitSeq.py group -s <input> -f DUPCOUNT --num 2 --outname <output>`

13. Fasta sequences were obtained from fastq files using seqtk 1.2-r94[4]. 
    
    `seqtk seq -a <input.fastq> > <fasta>`
    
14. The pre-processed sequences were then annotated using IgBLAST v1.6.1[5].
	
    ```
	igblastn -germline_db_V <V database> -germline_db_J <J_database> -germline_db_D <D database> 
    -organism rhesus_monkey -domain_system imgt -ig_seqtype Ig -query <fasta> -auxiliary_data <optional file> \
    -outfmt '7 std qseq sseq btop' -out IgBLAST/<blastout> -clonotype_out IgBLAST/clonotype/<clontype output>
    ```

15. Make database from IgBLAST using MakeDb.py from ChangeO 0.3.3 [6]

    ```
    MakeDb.py igblast -i <blastout> -s <fasta> -r IGH[VDJ].fa --regions --scores --outname <output>
    MakeDb.py igblast -i <blastout> -s <fasta> -r IGK[VJ].fa --regions --scores --outname <output>
    MakeDb.py igblast -i <blastout> -s <fasta> -r IGL[VJ].fa --regions --scores --outname <output>
    ```

16. Get Functional sequences

    `ParseDb.py split -d <input>  -f FUNCTIONAL --outname <output>`

17. Clonal assignment using get_clonotype.pl. Sequences are assigned to the same clonal family if they have: 
      (i) same V gene, 
     (ii) same J gene,
    (iii) same CDR3 length
     (iv) CDR3 nucleotide identity > 0.85
 
18. Clonal abundance was obtained using the countClones function.
	
	`countClones(db,copy="DUPCOUNT")`
 
19. V gene usage was obtained using the countGenes function.

	`countGenes(db, gene="V_CALL", mode="gene",copy="DUPCOUNT")`

20. Create germlines:
    ```
    CreateGermlines.py -d <input> -g dmask -r IGH[VDJ].fa --outdir Germlines
    CreateGermlines.py -d <input> -g dmask -r IGK[VJ].fa --outdir Germlines
    CreateGermlines.py -d <input> -g dmask -r IGL[VJ].fa --outdir Germlines
    ```

21. Mutations determined by observedMutations function from alakazam 0.2.10 and shazam 0.1.9 packages.

    `observedMutations(db_obs, sequenceColumn="SEQUENCE_IMGT",
                              germlineColumn="GERMLINE_IMGT_D_MASK",
                              regionDefinition=NULL,
                              frequency=TRUE, combine = TRUE`                          `

References:
1. Andrews S: FastQC: a quality control tool for high throughput sequence data. 2010.
2. Vander Heiden JA, Yaari G, Uduman M, Stern JN, O'Connor KC, Hafler DA, Vigneault F, Kleinstein SH: pRESTO: a toolkit for processing high-throughput sequencing raw reads of lymphocyte receptor repertoires. Bioinformatics 2014, 30:1930-1932.
3. Tange O: GNU Parallel - The Command-Line Power Tool,; login: The USENIX Magazine, February 2011:42-47.
4. https://github.com/lh3/seqtk/
5. Ye J, Ma N, Madden TL, Ostell JM: IgBLAST: an immunoglobulin variable domain sequence analysis tool. Nucleic Acids Res 2013, 41:W34-40.
6. Gupta NT, Vander Heiden JA, Uduman M, Gadala-Maria D, Yaari G, Kleinstein SH: Change-O: a toolkit for analyzing large-scale B cell immunoglobulin repertoire sequencing data. Bioinformatics 2015, 31:3356-3358.
