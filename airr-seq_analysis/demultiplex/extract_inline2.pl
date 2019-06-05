#!/usr/bin/perl -w
use strict;

# ./extract_inline.pl AGCGAGCT_Samples_S9_L001_R1_001.fastq.gz AACTCTAA 21_ROw16_RILN_wk-14_IgG 5

my $file = $ARGV[0];
my $index = $ARGV[1];
my $sample = $ARGV[2];
my $pre = $ARGV[3];

open IN,"$file" or die $!;
open OUT,">Separated_fastq2/$sample\.fastq" or die $!;

my $header1;
my $seq;
my $header2;
my $qual;

my $ctr=0;

while(my $ln = <IN>)
{
  $ctr++;
  $header1 = $ln;

  #print "$header1";

  $ln = <IN>;
  $seq = $ln;

  $ln = <IN>;
  $header2 = $ln;

  $ln = <IN>;
  $qual = $ln;

  my $seq2 = "AAGCAGTGGTATCAACGCAGAGT";
 
  if($seq=~/^.{$pre}$index$seq2/)
  {
      print OUT "$header1";
      $header1=~/^\@(\S+)/;
      print OUT "$seq";
      print OUT "$header2";
      print OUT "$qual";
  }
}
close IN;
