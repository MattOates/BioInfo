use BioInfo::Seq;

class BioInfo::Parser::FASTA::Actions {
    method TOP($/) {
        make $<record>>>.ast;
    }
    method record($/) {
        make BioInfo::Seq.new(
            id => ~$<id>,
            comment => ~$<comment>,
            sequence => $<sequence>.subst("\n","", :g)
        );
    }
}
