use BioInfo::Seq::Nucleic;

class BioInfo::Seq::DNA is BioInfo::Seq::Nucleic {
    has @.residues = ('T','C','A','G');
}
