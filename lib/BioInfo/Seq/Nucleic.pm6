use BioInfo::Seq;
use BioInfo::Seq::Amino;

my class X::BioInfo::WholeCodon is Exception {
    method message() {
        "Expected whole codon sequence, but the Nucleic acid sequence length received was not divisible by 3.";
    }
}

class BioInfo::Seq::Nucleic does BioInfo::Seq {

    has @.residues;

    method complement(:$reverse) {
        my %comp = zip @.residues, (@.residues[2,3], @.residues[0,1]);
        my $seq = self.sequence;
        $seq = $seq.flip if $reverse;
        self.new(
            id => self.id, 
            comment => self.comment, 
            sequence => $seq.comb.map({%comp{$_}}).join
        );
    }

    #Method to in-frame translate
    method translate(:$table='standard') {
        die X::BioInfo::WholeCodon.new() if $.sequence.chars % 3;

        #Get all the combinations of bases that map to the @aminos ordering
        #TTT TTC TTA TTG TCT TCC ... GGT GGC GGA GGG
            #my @codons = [X~] @.residues.item xx 3; #TODO work out why this no longer works?
        my @codons = map *~*~*, (@.residues X @.residues X @.residues);

        #Translation table
        #TODO add in the weirdy-beardy translation tables
        my %aminos = (standard => <F F L L S S S S
                                   Y Y * * C C * W
                                   L L L L P P P P
                                   H H Q Q R R R R
                                   I I I M T T T T
                                   N N K K S S R R
                                   V V V V A A A A
                                   D D E E G G G G>);

        #Create a map of the codons to amino acids
        #Anything non translatable like '-' or 'N' get mapped to X amino characters
        my %codon_table is default('X');
        %codon_table = zip @codons, %aminos{$table}.list;

        #Take all of the codons mapped to aminos and join them together
        BioInfo::Seq::Amino.new(
            id => self.id,
            comment => self.comment,
            sequence => %codon_table{map *~*~*, $.sequence.uc.comb}.join
        );
    }

    method three-frame-translate(:$min-length=1, :$break-on-stop, :$negative) {
        my @frames;
        for 0..2 -> $frame {
            my $seq;
            if ($negative) {
                $seq = (self.complement :reverse).sequence;
            } else {
                $seq = self.sequence;
            }
            #Start this frame shifted by the frame shift ammount
            $seq = $seq.substr($frame);
            #Chop off the end until we have whole codon length
            $seq = $seq.chop while $seq.chars % 3;
            #Create a new sequence object with the frame postfixed to the ID
            $seq = self.new(id => self.id ~ $frame + 1, comment => self.comment, sequence => $seq);

            #If breaking on stop codon was requested split this sequence up further into ORFs
            if ($break-on-stop) {
                $seq = $seq.translate;

                for $seq.sequence.comb(/<-[\*]>+/).kv -> $index, $orf {
                    @frames.push($seq.new(id => $seq.id ~ "_" ~ $index + 1, comment => $seq.comment, sequence => $orf)) if $orf.chars >= $min-length;
                }
            }
            #Otherwise just push the whole frame translation
            else {
                @frames.push($seq.translate) if $seq.sequence.chars >= $min-length;
            }
        }
        @frames;
    }

    method six-frame-translate(:$min-length=1,:$break-on-stop) {
        my @frames;
        push @frames, self.new(id => self.id ~ "/+", comment => self.comment, sequence => self.sequence).three-frame-translate(min-length=>$min-length) :break-on-stop($break-on-stop);
        push @frames, self.new(id => self.id ~ "/-", comment => self.comment, sequence => self.sequence).three-frame-translate(min-length=>$min-length) :break-on-stop($break-on-stop) :negative;
        @frames;
    }


}
