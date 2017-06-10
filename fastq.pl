#!/usr/bin/perl-w

use strict;

open FILE, '#######.fq' || die "Can not open"; #open your reference .fq file

open OUT1,'>basequality.txt'; #You can change the output file location
open OUT2,'>score.txt';
open OUT3,'>GC.txt';
open OUT4,'>duplication.txt'; #output of the 4 properties of the .fq file

$seq = 0;
$qual = 0;
$nl = 0;
$readnum = 0;

while (<FILE>) {
        chomp;
        $nl++;
        $readnum++;
      
        if ($nl == 2) {
                $seq = $_;
                if(exists $hashsq{$seq}) {
                        $hashsq{$seq}++;
                }
                else{
                        $hashsq{$seq} == 1;
                }
                $G = $seq =~ tr/G/G/;
                $C = $seq =~ tr/C/C/;
                $gc = int(100*($G + $C)/(length $seq));
                if(exists $hashgc{$gc}) {
                        $hashgc{$gc}++;
                }
                else{
                        $hashgc{$gc} == 1;
                }
        }
        elsif ($nl == 4) {
                $qual = $_;
                $count = 1;
                while($count <= (length $qual)) {
                        $p[$count] += 10**((-1)*(ord($qual[$count])-64));
                        $psc = 0;
                        $psc += 10**((-1)*(ord($qual[$count])-64));
                        $count++;
                }
                $sc = 0;
                $sc = int(-log($psc));
                if(exists $hashsc{$sc}) {
                        $hashsc{$sc}++;
                }
                else{
                        $hashsc{$sc} == 1;
                }
                $nl = 0;
        }
}

$count1 = 0;
$count2 = 0;
$Q = 0;
for($count1 < $readnum){
        for($count2 < 101){
                $Q[$count2] = int(-log($p[$count2]));
        }
}
for ($i=1; $i<=100; $i++){
        print OUT1 "$i $Q[i]/$readnum\n";
}

foreach $key (keys %hashsc) {
        $value = $hashsc{$key};
        print OUT2 "$key $value\n";
}

foreach $key (keys %hashgc) {
    $value = $hashgc{$key};
    print OUT3 "$key $value\n";
}

i = 0;
foreach (sort keys %hashsq) {
    $value = $hashsq{$key};
    for ($i=1; $i<=10; $i++){
        print OUT4 "$i $value\n";
        }
}
