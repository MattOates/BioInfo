use v6;
use Test;
plan 4;

use BioInfo::Parser::FASTA;
use BioInfo::IO::FileParseChannel;

{
    my $seqchan = BioInfo::IO::FileParseChannel.new(file => 't_data/pdb_aa.fa', parser => BioInfo::Parser::FASTA);
    isa_ok $seqchan, BioInfo::IO::FileParseChannel, 'Created FASTA Sequence IO Channel successfully.';

    my $seq = $seqchan.get();
    ok $seq.id eq '101m_A', 'Seq object, ID is parsed correctly.';
    ok $seq.comment eq 'mol:protein length:154  MYOGLOBIN', 'Seq object, comments are parsed correctly.';
    ok $seq.sequence eq 'MVLSEGEWQLVLHVWAKVEADVAGHGQDILIRLFKSHPETLEKFDRVKHLKTEAEMKASEDLKKHGVTVLTALGAILKKKGHHEAELKPLAQSHATKHKIPIKYLEFISEAIIHVLHSRHPGNFGADAQGAMNKALELFRKDIAAKYKELGYQG',
                        'Seq object, sequence is correctly parsed.';
}

done;
