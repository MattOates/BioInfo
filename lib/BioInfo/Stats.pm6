use v6;
package BioInfo::Stats {

    #Mean average
    proto sub mean($ --> Real) is export {*}
    multi sub mean(Baggy $x --> Real) {
        ( [+] $x.kv.map({$^k * $^v}) ) / $x.total;
    }
    multi sub mean(Positional $x --> Real) {
        ( [+] $x.list ) / $x.elems;
    }

    #Median average
    proto sub median($ --> Real) is export {*}
    multi sub median(Baggy $x --> Real) {
        #TODO Can do a lot better here by sorting by key and consuming half by value
        #return median($x.kxxv);
        my $n = ceiling $x.total / 2;
        if ($x.total % 2) {
            for $x.pairs.sort>>.kv -> $val, $freq {
                $n -= $freq;
                return $val if $n <= 0;
            }
        } else {
            my Real $prev;
            for $x.pairs.sort>>.kv -> $val, $freq {
                if $n - $freq <= 0 {
                    return $val if $n > 1;
                    say "On boundary of two bins using both values";
                    return ($val + $prev) / 2.0;
                }
                $n -= $freq;
                $prev = $val;
            }
        }

    }
    multi sub median(Positional $x --> Real) {
        $x := $x.sort;
        if ($x.elems % 2) {
            return 0.0 + $x[$x.elems / 2];
        } else {
            return 0.0 + ($x[($x.elems / 2) -1] + $x[$x.elems / 2]) / 2.0
        }
    }

    #Mode average
    proto sub mode($ --> Positional) is export {*}
    multi sub mode(Baggy $x --> Positional) {
        my $mode_freq = $x.values.max;
        $x.pairs.grep({.value == $mode_freq}).map({.key}).sort;
    }
    multi sub mode(Positional $x --> Positional) {
        mode(bag $x.list);
    }

    #Quartiles (Q1, Q2/Median, Q3)
    proto sub quartiles($ --> Positional) is export {*}
    multi sub quartiles(Positional $x --> Positional) {
        $x := $x.sort;
        (
        median($x[0..floor($x.elems/2)-1]),
        median($x),
        median($x[ceiling($x.elems/2)..$x.elems-1])
        )
    }

    #Inter-quartile range
    proto sub iqr($ --> Real) is export {*}
    multi sub iqr(Positional $x --> Real) {
        my ($q1,Nil,$q2) = quartiles($x);
        return $q2-$q1;
    }

    #Variance
    proto sub variance($ --> Real) is export {*}
    multi sub variance(Baggy $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.kv.map({(($^k - $mean)**2)*$^v}) ) / $x.total;
    }
    multi sub variance(Positional $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.map({($_ - $mean)**2}) ) / $x.elems;
    }

    #Standarad Deviation
    proto sub sd($ --> Real) is export {*}
    multi sub sd(Baggy $x --> Real) {
        sqrt(variance($x));
    }
    multi sub sd(Positional $x --> Real) {
        sqrt(variance($x));
    }

    #Mean Absolute Deviation
    proto sub mean-ad($ --> Real) is export {*}
    multi sub mean-ad(Baggy $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.kv.map({ abs($^k - $mean) *$^v }) ) / $x.total;
    }
    multi sub mean-ad(Positional $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.map({ abs($_ - $mean) }) ) / $x.elems;
    }

    #Median Absolute Deviation
    proto sub median-ad($ --> Real) is export {*}
    multi sub median-ad(Baggy $x --> Real) {
        my $median = median($x);
        #TODO look into using the Bag form of the median here too
        median( $x.kv.map({ abs($^k - $median) xx $^v }) );
    }
    multi sub median-ad(Positional $x --> Real) {
        my $median = median($x);
        median( $x.map({ abs($_ - $median) }) );
    }

    #Map data values to their zscores as a list of pairs
    proto sub zscores($ --> Positional) is export {*}
    multi sub zscores(Baggy $x --> Positional) {
        my $mean = mean($x);
        my $sd = sd($x);
        $x.pairs.map({$_.key => ($_.key - $mean) / $sd }).sort({$^a.value <=> $^b.value});
    }
    multi sub zscores(Positional $x --> Positional) {
        my $mean = mean($x);
        my $sd = sd($x);
        $x.map({$_ => ($_ - $mean) / $sd }).sort({$^a.value <=> $^b.value}).squish(as => {.key});
    }

    #Get the zscore for a new value given a previous sample of observations
    #This is a common way of ranking new observations on how over or under represented they are given a background
    proto sub zscore($,$ --> Positional) is export {*}
    multi sub zscore(Numeric $x, $X where $X.WHAT ~~ Baggy|Positional --> Real) {
        my $mean = mean($X);
        my $sd = sd($X);
        ($x - $mean) / $sd;
    }

    #Summary statistics Rlang style
    proto sub summary($ --> Positional) is export {*}
    multi sub summary(Positional $x --> Positional) {
        my $median = median($x);
        (
        'mean'=>mean($x),
        'sd'=>sd($x),
        'quartiles'=>quartiles($x),
        'min'=>min($x),
        'max'=>max($x)
        )
    }

    #Calculate a binned histogram of the data
    proto sub hist($ --> Positional) is export {*}
    multi sub hist(Positional $x, :$breaks('') --> Positional) {
        my $bin-width;
        given $breaks {
            when 'Doane' {*} #Looks cool but needs some other dist related functions
            when 'Square-root choice' { $bin-width = abs($x.max - $x.min) / sqrt($x.elems); }
            when 'Freedman-Diaconis' {*}
            when 'Rice' { $bin-width = abs($x.max - $x.min) / 2*($x.elems ** 1/3); }
            when 'Sturges' { $bin-width = abs($x.max - $x.min) / log($x.elems,2)+1; }
            when 'Scott' {*}
            default { fail "Unknown binning method."; }
        }
    }

}
