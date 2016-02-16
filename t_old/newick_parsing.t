use v6;
use Test;
plan 1;

use BioInfo::Parser::Newick;
use BioInfo::IO::FileParser;

{
    my $treechan = BioInfo::IO::FileParser.new(file => 't_data/quoted.nwk', parser => BioInfo::Parser::Newick);
    isa-ok $treechan, BioInfo::IO::FileParser, 'Created Newick File IO Channel successfully.';
}

done-testing;
