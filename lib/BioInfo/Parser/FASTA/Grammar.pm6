grammar BioInfo::Parser::FASTA::Grammar {
    token TOP {
        <.ws> <record>+ || <sequence>
    }

    token record {
        ">"<id>" "<comment>"\n"<sequence>
    }

    token id {
        <-[\ ]>+
    }
    token comment {
        <-[\n]>+
    }

    proto token sequence {*}
    token sequence:sym<dna> {
        <[ACGTRYKMSWBDHVNX\-\n]>+
    }
    token sequence:sym<rna> {
        <[ACGURYKMSWBDHVNX\-\n]>+
    }
    token sequence:sym<aa> {
        <[A..Z\*\-\n]>+
    }
    token sequence:sym<seq> {
        <-[>]>+
    }

}
