#!/usr/bin/perl -w
use strict;

use Set::Scalar;
use Graph::UnionFind;

my %cluster;

my $thr = $ARGV[1];


sub compare_arr
{
	my ($str_1,$str_2) = @_;
	my $match = 0;

	my @arr1 = split(",",$str_1);
	my @arr2 = split(",",$str_2);

	foreach my $a1(@arr1)
	{
		foreach my $a2(@arr2)
		{
			$a1=~s/\*.*//;
			$a2=~s/\*.*//;
			if($a1 eq $a2)
			{
				$match = 1;
				last;
			}
		}
	}
	return $match;
}


sub compare_cdr3
{
	my ($cdr3_1,$cdr3_2) = @_;
	my $match = 0;
	if(length($cdr3_1) == length($cdr3_2))
	{
		my $len =  length($cdr3_1);
		my $count = ( $cdr3_1 ^ $cdr3_2 ) =~ tr/\0//c;

		my $per = 1-($count/$len);
		#print "$cdr3_1\t$cdr3_2\t$count\t$len\t$per\n";
		if($per > $thr)
		{
			$match = 1;
		}
	}
	return $match;
}




my $db_head;
my %db;
my %clonotype;
open IN,"$ARGV[0]" or die $!;
my $ln = <IN>;
$ln=~s/\r|\n//g;
$db_head = $ln;

while($ln = <IN>)
{
	$ln=~s/\r|\n//g;

	# SEQUENCE_ID     	0
	# SEQUENCE_INPUT  	1
	# FUNCTIONAL      	2
	# IN_FRAME        	3
	# STOP				4
	# MUTATED_INVARIANT 5      
	# INDELS  6
	# V_CALL  7
	# D_CALL  8
	# J_CALL  9
	# SEQUENCE_VDJ    10
	# SEQUENCE_IMGT   11
	# V_SEQ_START     12
	# V_SEQ_LENGTH    13
	# V_GERM_START_VDJ  14      
	# V_GERM_LENGTH_VDJ   15
	# V_GERM_START_IMGT   16   
	# V_GERM_LENGTH_IMGT  17   
	# NP1_LENGTH      18
	# D_SEQ_START     19
	# D_SEQ_LENGTH    20
	# D_GERM_START    21
	# D_GERM_LENGTH   22
	# NP2_LENGTH      23
	# J_SEQ_START     24
	# J_SEQ_LENGTH    25
	# J_GERM_START    26
	# J_GERM_LENGTH   27
	# JUNCTION_LENGTH 28
	# JUNCTION 29
	# FWR1_IMGT  30      
	# FWR2_IMGT  31    
	# FWR3_IMGT  32   
	# FWR4_IMGT  33     
	# CDR1_IMGT  34     
	# CDR2_IMGT  35     
	# CDR3_IMGT  36     
	# V_SCORE 	  37	
	# V_IDENTITY  38    
	# V_EVALUE    39    
	# V_BTOP      40
	# J_SCORE     41
	# J_IDENTITY  42    
	# J_EVALUE    43    
	# J_BTOP      44
	# SEQORIENT   45    
	# VPRIMER     46
	# DUPCOUNT    47
 
	my @arr = split("\t",$ln);	
	$db{$arr[0]} = $ln;

	$clonotype{$arr[0]}{'V'} = $arr[7];
	$clonotype{$arr[0]}{'J'} = $arr[9];
	$clonotype{$arr[0]}{'junc_len'} = $arr[28];
	$clonotype{$arr[0]}{'junc'} = $arr[29];

	$clonotype{$arr[0]}{'cdr3_len'} = $arr[28] - 6;
	$arr[29]=~/...(.*).../;
	$clonotype{$arr[0]}{'cdr3'} = $1;
	
	#print  "$arr[0]\t$arr[29]\t$arr[28]\t$1\t$clonotype{$arr[0]}{'cdr3_len'}\n";
	
}

my $uf100 = Graph::UnionFind->new;
my %v100;

foreach my $s1 (sort keys %clonotype)
{
	foreach my $s2(sort keys %clonotype)
	{
		#if($s1 eq $s2) {next;}
		#print "$s1\t$s2\n";
		my $hv_check = compare_arr($clonotype{$s1}{'V'},$clonotype{$s2}{'V'});
		my $hj_check = compare_arr($clonotype{$s1}{'J'},$clonotype{$s2}{'J'});
		#my $hcdr3_check = compare_cdr3($clonotype{$s1}{'junc'},$clonotype{$s2}{'junc'});
		my $hcdr3_check = compare_cdr3($clonotype{$s1}{'cdr3'},$clonotype{$s2}{'cdr3'});
		
		if($hv_check && $hj_check && $hcdr3_check)
		{		
			++$v100{$_} for $s1,$s2;
    		$uf100->union($s1,$s2);
		}
	}
}

my %c100;
foreach my $v (keys %v100)
{
	#print "Vertex $v\n";
    my $b = $uf100->find($v);
    die "$0: no block for $v" unless defined $b;
    #print "$b\t$v\n";	
    push @{ $c100{$b} }, $v;
}


my %clones;
my $ctr = 0;
foreach my $a(keys %c100)
{
	$ctr++;
	foreach my $seq(@{$c100{$a}})
	{
		$clones{$seq} = $ctr;
		# print "$seq\t$ctr\t$clonotype{$seq}{'V'}\t$clonotype{$seq}{'J'}\t$clonotype{$seq}{'junc'}\t$clonotype{$seq}{'junc_len'}\n";
	}
	
}

open OUT,">$ARGV[0].clones.tab" or die $!;
print OUT "$db_head\tCLONE\n";
foreach my $seq(keys %db)
{
	print OUT "$db{$seq}\t$clones{$seq}\n";
}