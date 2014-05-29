role BioInfo::Seq {
    has Str $.id = "";
    has Str $.comment = "";
    has Str $.sequence = "";

    multi method Numeric (BioInfo::Seq:D: --> Numeric) {
        $.sequence.codes;
    }

    multi method Bag (--> Bag) {
        bag $.sequence.split('');
    }

    multi method Str (BioInfo::Seq:D: --> Str) {
        ">$.id $.comment\n$.sequence\n";
    }

    multi method gist (BioInfo::Seq:D: --> Str) {
        self.Str;
    }
}
