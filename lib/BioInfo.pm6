use QAST:from<NQP>;
 
sub BioInfo::seq(Str $sequence) is export {
    use BioInfo::Parser::FASTA::Grammar;
    use BioInfo::Parser::FASTA::Actions;
    BioInfo::Parser::FASTA::Grammar.parse($sequence, actions => BioInfo::Parser::FASTA::Actions).ast;
}
 
sub EXPORT(|) {
    role BioInfo::Grammar {
        token quote:sym<` `> {
        '`' <bioseq> [ '`' || <.panic: "Unable to parse bio sequence; couldn't find final '`'"> ]
        }
        token bioseq { <-[`]>* }
    }
 
    role BioInfo::Actions {
        method quote:sym<` `>(Mu $/ is rw) {
            my $seq := nqp::atkey(nqp::findmethod($/, 'hash')($/), 'bioseq');
            my $call := QAST::Op.new(
                                :op<call>,
                                :name<&BioInfo::seq>,
                                QAST::SVal.new(:value($seq.Str))
                        );
            $/.'!make'($call);
        }
    }
 
    nqp::bindkey(%*LANG, 'MAIN', %*LANG<MAIN>.HOW.mixin(%*LANG<MAIN>, BioInfo::Grammar));
    nqp::bindkey(%*LANG, 'MAIN-actions', %*LANG<MAIN-actions>.HOW.mixin(%*LANG<MAIN-actions>, BioInfo::Actions));
    {}
} 
