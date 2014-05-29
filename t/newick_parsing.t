use v6;
use Test;
plan 1;

use BioInfo::Parser::Newick;
use BioInfo::IO::FileParseChannel;

{
    my $treechan = BioInfo::IO::FileParseChannel.new(file => 't_data/quoted.nwk', parser => BioInfo::Parser::Newick);
    isa_ok $treechan, BioInfo::IO::FileParseChannel, 'Created Newick File IO Channel successfully.';
}

done;
