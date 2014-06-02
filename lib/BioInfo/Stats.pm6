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
        return median($x.kxxv);
    }
    multi sub median(Positional $x --> Real) {
        $x := $x.sort;
        if ($x.elems % 2) {
            return 0.0 + $x[$x.elems / 2];
        } else {
            return 0.0 + ($x[($x.elems / 2) -1] + $x[$x.elems / 2]) / 2.0
        }
    }

    proto sub sd($ --> Real) is export {*}
    multi sub sd(Baggy $x --> Real) {
        my $mu = mean($x);
        my $sigma = 0;
        $sigma = sqrt(( [+] $x.kv.map({(($^k - $mu)**2)*$^v}) ) / $x);
        $sigma;
    }
    multi sub sd(Positional $x --> Real) {
        my $mu = mean($x);
        my $sigma = 0;
        $sigma = sqrt(( [+] $x.map({($_ - $mu)**2}) ) / $x.elems);
        $sigma;
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

}
