class BioInfo::Parser::Newicj::Actions {
    method TOP($/) {
        make $<tree>>>.ast;
    }
}
