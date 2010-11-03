#!perl -w
use strict;
use Data::Dumper;
use File::Slurp;

#my $data = read_file $ARGV[0];
#warn  unpack 'b*', $data;
#
#my $data_pr = unpack 'b*', substr($data, 22);
#warn $data_pr;
#warn substr($data_pr, 0,2);
#print pack 'b*', '000000'.substr($data_pr, 0,2);
#print pack 'B*', '000000'.substr($data_pr, 0,2);


my $a = '10101010';
warn $a & '00000011';




