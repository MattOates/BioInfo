use BioInfo::Seq::Nucleic;

class BioInfo::Seq::RNA is BioInfo::Seq::Nucleic {
    has @.residues = ('U','C','A','G');
}
