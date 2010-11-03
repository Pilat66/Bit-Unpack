use strict;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Data::Dumper;
use File::Find;
use File::Slurp;
use Inmarsat::API_Header;
#use Inmarsat::PositionReport;
use Bit::Unpack;

sub print_data {
	return unless -f $File::Find::name;
	return unless $File::Find::name =~ /\.att$/;
	print $File::Find::name, "\n";
	my $data = read_file($File::Find::name);
	print Dumper( Inmarsat::API_Header::parse_API_Header($data) );
    write_file "$File::Find::name" . '.head', substr( $data, 0,22 );
	my $data_position_report = substr( $data, 22 );
	warn length($data_position_report);
	write_file "$File::Find::name" . '.data', $data_position_report;
#    print Dumper( Inmarsat::PositionReport::parse_PositionReport($data_position_report) );
	warn Dumper( [ BitParse::bit_unpack($data_position_report, qw[C2 C1 C7 C6 C5 C1 C8 C6 C5 C7] ) ] );

} ## end sub print_api_header

find( { wanted => \&print_data, no_chdir => 1 }, @ARGV, );

#warn Dumper( [ BitParse::decode_bits( '!!!!!!!!', qw[c8 c8 c8 c8 c8 c8 c8 C8] ) ] );
#warn Dumper( [ BitParse::decode_bits( pack( 'SS',0xFFFF,0xFFFF),     qw[s16 S16] ) ] );
