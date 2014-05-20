use v6;
use Test;
plan 1;

use BioInfo::Parser::Newick;
use BioInfo::IO::FileParseChannel;

{
    my $treechan = BioInfo::IO::FileParseChannel.new(file => 't_data/test.nwk', parser => BioInfo::Parser::Newick);
    isa_ok $treechan, BioInfo::Seq::IOChannel, 'Created Newick File IO Channel successfully.';

    my $tree = $treechan.get();
}

done;
