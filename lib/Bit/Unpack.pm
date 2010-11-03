package Bit::Unpack;
use strict;
use utf8;

use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION @CONFIG %EXPORT_TAGS);
require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw(&bit_unpack);

@EXPORT_OK = qw(&bit_unpack);

%EXPORT_TAGS = ( all => [@EXPORT_OK] );

$VERSION = '0.1';

my %typelen = (
# c A signed char (8-bit) value.
# C An unsigned char (octet) value.
	'c' => 1,
	'C' => 1,
# W An unsigned char value (can be greater than 255).
#
# s A signed short (16-bit) value.
# S An unsigned short value.
	's' => 2,
	'S' => 2,
#
# l A signed long (32-bit) value.
# L An unsigned long value.
	'l' => 4,
	'L' => 4,
#
# q A signed quad (64-bit) value.
# Q An unsigned quad value.
	'q' => 8,
	'Q' => 8,
# (Quads are available only if your system supports 64-bit
# integer values _and_ if Perl has been compiled to support those.
# Raises an exception otherwise.)
#
# i A signed integer value.
# I A unsigned integer value.
	'i' => 4,
	'I' => 4,
# (This 'integer' is _at_least_ 32 bits wide. Its exact
# size depends on what a local C compiler calls 'int'.)
#
# n An unsigned short (16-bit) in "network" (big-endian) order.
	'n' => 2,
# N An unsigned long (32-bit) in "network" (big-endian) order.
	'N' => 4,
# v An unsigned short (16-bit) in "VAX" (little-endian) order.
	'v' => 2,
# V An unsigned long (32-bit) in "VAX" (little-endian) order.
	'V' => 4,
#
# j A Perl internal signed integer value (IV).
# J A Perl internal unsigned integer value (UV).
#
# f A single-precision float in native format.
# d A double-precision float in native format.
#
# F A Perl internal floating-point value (NV) in native format
# D A float of long-double precision in native format.
# (Long doubles are available only if your system supports long
# double values _and_ if Perl has been compiled to support those.
# Raises an exception otherwise.)
);

=head2 bit_unpack()

    my @array = BitParse::bit_unpack($data, qw[C2 C1 C7 C6 C5 C1 C8 C6 C5 C7] );
    my $arrayref = BitParse::bit_unpack($data, qw[C2 C1 C7 C6 C5 C1 C8 C6 C5 C7] );
    my @array = BitParse::bit_unpack($data, "C2 C1 C7 C6 C5 C1 C8 C6 C5 C7" );
    my $arrayref = BitParse::bit_unpack($data, "C2 C1 C7 C6 C5 C1 C8 C6 C5 C7" );
    my @array = BitParse::bit_unpack($data, "C2 C1 C7", "C6 C5 C1 C8 C6 C5 C7" );


=cut

sub bit_unpack {
	my $data      = shift;
	my @_template = @_;
	my @tmp;
	my @result;

	foreach (@_template) {
		push @tmp, split /\s+/, $_;
	} ## end foreach (@_template)
	    #warn unpack( 'H*', $data );
	    #warn unpack( 'h*', $data );
	my $bits = unpack( 'B*', $data );
	my $bits_length = length($bits);
	my $start = 0;
    #warn "\nbits=" . $bits;

	foreach my $item (@tmp) {

		if ( $item =~ /^([a-z])(\d+)$/io ) {
			my $type = $1;
#warn "type=" . $type;
			die("Unsupported type '$1'") unless $typelen{$type};
			my $len = $2;
#warn "len=" . $len;
			my $len_bytes = int( ( $len + 7 ) / 8 );
#warn "len_bytes=" . $len_bytes;
			die(
				"Invalid length for type '$type', present '$len' bits == $len_bytes bytes, but '$typelen{$type}' bytes expected"
			) unless $len_bytes <= $typelen{$type};
			die("Bits not enough") unless $start+$len <= $bits_length;
			my $d = substr( $bits, $start, $len );
			$start += $len;
#warn "d=" . $d;
#substr( $bits, 0, $len ) = '';
			$d = ( '0' x ( $typelen{$type} * 8 - $len ) ) . $d;
#warn "d=" . $d;
			my $number = pack 'B*', $d;
#warn "number='" . $number."'";
			$number = unpack $type, $number;
#warn "number=" . $number;
			push @result, $number;
		} ## end if ( $item =~ /^([a-z])(\d+)$/io)
	} ## end foreach my $item (@tmp)
	return @result if wantarray;
	return \@result;
} ## end sub bit_unpack

1;
