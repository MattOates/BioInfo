use v6;
use Test;
plan 16;

#Basic sanity tests for the stats functions, no real coverage of edge cases
use BioInfo::Stats;

{
    my @positional_x = (1,2,3,3,4,5,5,6,7);
    my $baggy_x = bag @positional_x;
    ok mean(@positional_x) == 4.0, 'Mean was correctly calculated.';
    ok median(@positional_x) == 4.0, 'Median was correctly calculated.';
    ok mode(@positional_x) eqv (3, 5), 'Mode was correctly calculated.';
    ok iqr(@positional_x) == 3.0, 'Inter-quartile range correctly calculated.';
    ok quartiles(@positional_x) eqv $(2.5, 4.0, 5.5), 'Quartiles correctly calculated.';
    ok variance(@positional_x) == 10/3, 'Variance correctly calculated.';
    ok sd(@positional_x) == sqrt(10/3), 'Standard deviation correctly calculated.';
    ok mean-ad(@positional_x) == 14/9, 'Mean Absolute Deviation correctly calculated.';
    ok median-ad(@positional_x) == 1, 'Median Absolute Deviation correctly calculated.';
    ok mean(@positional_x) == mean($baggy_x), 'Mean for Bag and Array is identical.';
    ok median(@positional_x) == median($baggy_x), 'Median for Bag and Array is identical.';
    ok mode(@positional_x) eqv mode($baggy_x), 'Mode for Bag and Array is identical.';
    ok variance(@positional_x) == variance($baggy_x), 'Variance for Bag and Array is identical.';
    ok sd(@positional_x) == sd($baggy_x), 'Standard deviation for Bag and Array is identical.';
    ok mean-ad(@positional_x) == mean-ad($baggy_x), 'Mean Absolute Deviation for Bag and Array is identical.';
    ok median-ad(@positional_x) == median-ad($baggy_x), 'Median Absolute Deviation for Bag and Array is identical.';
}

done;
