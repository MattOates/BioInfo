use BioInfo::Seq;
use BioInfo::Seq::DNA;
use BioInfo::Seq::RNA;
use BioInfo::Seq::Amino;

class BioInfo::Parser::FASTA::Actions {
    method TOP($/) {
        make $<record>>>.ast;
    }
    method record($/ is rw) {
        $<sequence>.ast[0].id = ~$<id>;
        $<sequence>.ast[0].comment = ~$<comment>;
        make $<sequence>.ast;
    }
    method sequence:sym<dna>($/ is rw) {
        make BioInfo::Seq::DNA.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
    method sequence:sym<rna>($/ is rw) {
        make BioInfo::Seq::RNA.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
    method sequence:sym<aa>($/ is rw) {
        make BioInfo::Seq::Amino.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
    method sequence:sym<seq>($/ is rw) {
        make BioInfo::Seq.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
}
