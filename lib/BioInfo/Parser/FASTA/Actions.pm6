use BioInfo::Seq;
use BioInfo::Seq::DNA;
use BioInfo::Seq::RNA;
use BioInfo::Seq::Amino;

class BioInfo::Parser::FASTA::Actions {
    method TOP($/) {
        make $<record>>>.ast;
    }
    method record($/) {
        $<sequence>.ast[0].id = ~$<id>;
        $<sequence>.ast[0].comment = ~$<comment>;
        make $<sequence>.ast;
    }
    method sequence:sym<dna>($/) {
        make BioInfo::Seq::DNA.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
    method sequence:sym<rna>($/) {
        make BioInfo::Seq::RNA.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
    method sequence:sym<aa>($/) {
        make BioInfo::Seq::Amino.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
    method sequence:sym<seq>($/) {
        make BioInfo::Seq.new(
            sequence => ~$/.subst("\n","", :g)
        );
    }
}
