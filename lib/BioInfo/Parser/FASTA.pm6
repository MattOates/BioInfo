use BioInfo::Parser;
use BioInfo::Parser::FASTA::Grammar;
use BioInfo::Parser::FASTA::Actions;

class BioInfo::Parser::FASTA does BioInfo::Parser {
    method rec-start { ">" };
    method actions { BioInfo::Parser::FASTA::Actions; }
    method grammar { BioInfo::Parser::FASTA::Grammar; }
}
