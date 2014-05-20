use BioInfo::Parser;
use BioInfo::Parser::Newick::Grammar;
use BioInfo::Parser::Newick::Actions;

class BioInfo::Parser::Newick does BioInfo::Parser {
    method rec-start { Nil }
    method rec-end { ";" }
    method actions { BioInfo::Parser::Newick::Actions }
    method grammar { BioInfo::Parser::Newick::Grammar }
}
