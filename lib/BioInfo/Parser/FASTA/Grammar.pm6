grammar BioInfo::Parser::FASTA::Grammar {
    token TOP {
        <record>+
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
    token sequence:sym<aa> {
        <[A..Z\*\-\n]>+
    }
    token sequence:sym<dna> {
        <[ACGTRYKMSWBDHVNX\-\n]>+
    }
    token sequence:sym<rna> {
        <[ACGURYKMSWBDHVNX\-\n]>+
    }

}
