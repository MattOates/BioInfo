BioInfo
=========

BioInfo is a reimagining of bioinformatics libraries for Perl6 based on all the new goodies available such as parallel processing through Promises and Channels and well defined and extensible parsing with the use of Grammars. Not to be confused with the [bioperl6] project lead by [Chris Fields] which aims to be a reimplementation of the BioPerl API for Perl6. Checkout Chris' project for any serious business.


###The Good
  - Being built to work in parallel use cases so you don't have to worry too much about this yourself.
  - Using sped up parse as you go forms of Perl6 Grammars so that a whole file isn't read into RAM and you can just play with getting higher level objects quickly.
  - I'll attempt to work on reasonable requests for anything, pull requests are welcome just maybe contact me first if you have to make some big architectural decisions to get what you want.
  - A fresh project for anyone who has an opinon to get involved pushing that opinion on others.

###The Bad
  - I'm mostly ignoring BioPerl.
  - Like the [bioperl6] project I am trying things out so the API is in flux. If you want something production ready, you're going to have to help to get there.

###The Ugly
  - The author of these modules ([Matt Oates]) mostly concerns himself with amino acid sequences so other considerations are secondary. Sorry about that.
  - [bioperl6] does exist. So this is a bit of a split effort, really [bioperl6] should get any attention.

---

##An Example

```perl6
use BioInfo::Parser::FASTA;
use BioInfo::IO::FileParser;

#Spawn an IO thread that parses the file and creates BioInfo::Seq objects on .get
my $seq_file = BioInfo::IO::FileParser.new(file => 'myseqs.fa', parser => BioInfo::Parser::FASTA);

#Print all the IDs from the sequence file
while (my $seq = $seq_file.get()) {
    say $seq.id;
}

```

---

##Installation

Installation is quite simple at the moment, but might become more involved once third party software is involved.

### With panda (part of the Rakudo* distribution)
###### I havent added this to the Panda modules listings yet... When it is:
```sh
panda install BioInfo
perl6 -M BioInfo -e 'say BioInfo::Seq.new(id => "seq1", sequence => "MDADAFA");'
```

### By hand

```sh
#Get the code into your library path
cd ~/wherever_you_keep_perl6_libs
git clone 'https://github.com/MattOates/BioInfo'
#Run some tests
cd BioInfo
prove -e 'perl6 -I ./lib' -lrv t/
```

---

##License

Artistic, for now just so that I don't have to worry about hardcore Perl users being fearful of anything else.

[Chris Fields]:http://www.bioperl.org/wiki/User:Cjfields
[bioperl6]:https://github.com/cjfields/bioperl6/
[Matt Oates]:http://bioinformatics.bris.ac.uk/people/matt_oates.php
