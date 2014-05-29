use v6;
package BioInfo::Stats {

proto sub mean($ --> Real) is export {*}
multi sub mean(Baggy $b --> Real) {
    ( [+] $b.kv.map({$^k * $^v}) ) / $b.total;
}
multi sub mean(Positional $l --> Real) {
    ( [+] $l.list ) / $l.elems;
}

proto sub mode($ --> Real) is export {*}
multi sub mode(Baggy $b --> Real) {

}
multi sub mode(Positional $l --> Real) {
    #should be some form of binning/hist here assuming real valued items
    mode(bag $l.list);
}

proto sub stddev($ --> Real) is export {*}
multi sub stddev(Baggy $b --> Parcel) {
    my $mu = mean($b);
    my $sigma = 0;
    $sigma = sqrt(( [+] $b.kv.map({(($^k - $mu)**2)*$^v}) ) / $b);
    ($mu, $sigma);
}
multi sub stddev(Positional $l --> Parcel) {
    my $mu = mean($l);
    my $sigma = 0;
    $sigma = sqrt(( [+] $l.map({($_ - $mu)**2}) ) / $l.elems);
    ($mu, $sigma);
}
}
