BioInfo
=========

BioInfo is a reimagining of bioinformatics libraries for Perl based on all the new goodies available such as parallel processing through Promises and Channels. Not to be confused with the [bioperl6] project lead by [Chris Fields] which aims to be a reimplementation of the BioPerl API for Perl6. Checkout Chris' project for any serious business.

###The Good
  - Being built to work in parallel use cases so you don't have to worry too much about this yourself.
  - Using sped up parse as you go forms of Perl6 Grammars so that a whole file isn't read into RAM and you can just play with getting higher level objects quickly.
  - I'll attempt to work on reasonable requests for anything, pull requests are welcome just maybe contact me first if you have to make some big architectural decisions to get what you want.
  - A fresh project for anyone who has an opinon to get involved pushing that opinion on others.

###The Bad
  - I'm mostly ignoring BioPerl. I've gotten by only ever using SeqIO from BioPerl, which I thought was really well done but the [bioperl6] modules so far aren't at parity with the Perl5 implementation. I'm doing this for fun, and want classes and objects I like. If there is something so well done in BioPerl I will happily borrow liberally.
  - Like the [bioperl6] project I am trying things out so the API is in flux. If you want something production ready, you're going to have to help to get there.

###The Ugly
  - The author of these modules ([Matt Oates]) mostly concerns himself with amino acid sequences so other considerations are secondary. Sorry about that. I am interseted in gene architecture and how it relates to proteins, so DNA/RNA specific concerns will get there eventually. Hopefully most sequence level stuff will be generic enough.
  - bioperl6 does exist. So this is a bit of a split effort, really bioperl6 should get any attention. At the time of writing most of bioperl6 is stubs or stuff that doesn't compile, or suffers from perf problems because the "correct" Perl6 was used over what works now in Rakudo efficiently. Ultimately this will pay off in bioperl6's favour. 
  - BioInfo doesn't even have stubs! It has like five classes that parse FASTA files efficiently at the moment.

---

##An Example

```perl6
use BioInfo::Parser::FASTA;
use BioInfo::Seq::IOChannel;

my $channel = BioInfo::Seq::IOChannel.new(file => 'myseqs.fa', parser => BioInfo::Parser::FASTA);

#Print all the IDs from the sequence file
while (my $seq = $channel.get()) {
    say $seq.id;
}

```

---

##Installation

Installation is quite simple at the moment, but might become more involved once third party software is involved.

### With panda (part of the Rakudo* distribution)

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
