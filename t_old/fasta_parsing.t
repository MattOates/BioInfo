use v6;
use Test;
plan 1;

use BioInfo::Parser::FASTA;
use BioInfo::IO::FileParser;

{
    my $seqchan = BioInfo::IO::FileParser.new(file => 't_data/pdb_aa.fa', parser => BioInfo::Parser::FASTA);
    isa-ok $seqchan, BioInfo::IO::FileParser, 'Created FASTA Sequence IO Channel successfully.';

    # my $seq = $seqchan.get();
    # ok $seq.id eq '101m_A', 'Seq object, ID is parsed correctly.';
    # ok $seq.comment eq 'mol:protein length:154  MYOGLOBIN', 'Seq object, comments are parsed correctly.';
    # ok $seq.sequence eq 'MVLSEGEWQLVLHVWAKVEADVAGHGQDILIRLFKSHPETLEKFDRVKHLKTEAEMKASEDLKKHGVTVLTALGAILKKKGHHEAELKPLAQSHATKHKIPIKYLEFISEAIIHVLHSRHPGNFGADAQGAMNKALELFRKDIAAKYKELGYQG', 'Seq object, sequence is correctly parsed.';
}

done-testing;
