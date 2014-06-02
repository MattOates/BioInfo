use v6;
package BioInfo::Stats {

    proto sub mean($ --> Real) is export {*}
    multi sub mean(Baggy $x --> Real) {
        ( [+] $x.kv.map({$^k * $^v}) ) / $x.total;
    }
    multi sub mean(Positional $x --> Real) {
        ( [+] $x.list ) / $x.elems;
    }

    proto sub quartiles($ --> Parcel) is export {*}
    multi sub quartiles(Positional $x --> Parcel) {
        $x := $x.sort;
        (
        median($x[0..floor($x.elems/2)-1]),
        median($x),
        median($x[ceiling($x.elems/2)..$x.elems-1])
        )
    }

    proto sub iqr($ --> Real) is export {*}
    multi sub iqr(Positional $x --> Real) {
        my ($q1,Nil,$q2) = quartiles($x);
        return $q2-$q1;
    }

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

    proto sub variance($ --> Real) is export {*}
    multi sub variance(Baggy $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.kv.map({(($^k - $mean)**2)*$^v}) ) / $x.total;
    }
    multi sub variance(Positional $x) {
        my $mean = mean($x);
        ([+] $x.map({($_ - $mean)**2}) ) / $x.elems;
    }

    proto sub sd($ --> Real) is export {*}
    multi sub sd(Baggy $x --> Real) {
        sqrt(variance($x));
    }
    multi sub sd(Positional $x --> Real) {
        sqrt(variance($x));
    }

    proto sub summary($ --> Parcel) is export {*}
    multi sub summary(Positional $x --> Parcel) {
        my $median = median($x);
        (
        'mean'=>mean($x),
        'sd'=>sd($x),
        'quartiles'=>quartiles($x),
        'min'=>min($x),
        'max'=>max($x)
        )
    }

    proto sub hist($ --> Parcel) is export {*}
    multi sub hist(Positional $x, :$breaks('') --> Parcel) {
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
