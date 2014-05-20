grammar BioInfo::Parser::Newick::Grammar {

    rule TOP {
        <tree>+
    }

    rule tree {
        <node> ";"
    }

    rule node {
        <children> <label>? <distance>? | <children>? <label> <distance>?
    }

    rule children {
        "(" <node> ("," <node>)* ")"
    }

    rule label {
        <quoted> | <unquoted>
    }

    rule distance {
        ":" <number>
    }

    token quoted { "'" ( <-[']> | "''" )* "'" }
    #token unquoted { <[A..Z]>* }
    token unquoted { <-[\[\]()':\s]>* }
    token number { <[+-]>?\d+"."?\d*<[eE]>?\d* }

}
