#!/usr/bin/perl
##################################################################################
# This plugin runs iostat for a specified partition and alerts based on defined
# thresholds.
# Author: Rodrigo Hernandez.
# Date: 09/04/2012
# Exit codes: 0=OK 1=Warn 2=Critical 3=Unknown
##################################################################################
use strict;
use Getopt::Long qw(:config no_ignore_case bundling);

# Define variables
my ($help, $dev, $tps, $brs, $bws, $br, $bw, $tps_w, $tps_c, $brs_w, $brs_c, $bws_w, $bws_c);

# Get options
GetOptions(
    'a=s'  => \$dev, 'device=s' => \$dev,
    'o=i'  => \$tps_w, 'tps_w=i' => \$tps_w,
    'p=i'  => \$tps_c, 'tps_c=i' => \$tps_c,
    'q=i'  => \$brs_w, 'brs_w=i' => \$brs_w,
    'r=i'  => \$brs_c, 'brs_c=i' => \$brs_c,
    's=i'  => \$bws_w, 'bws_w=i' => \$bws_w,
    't=i'  => \$bws_c, 'bws_c=i' => \$bws_c,
    'h'    => \$help, 'help' => \$help,
    );

# Constant values and hash var for exit codes
my $unk_exit = 3;
my $crit_exit = 2;
my $warn_exit = 1;
my $ok_exit = 0;

my %exit = ($unk_exit => 'UNKNOWN', $crit_exit => 'CRITICAL', $warn_exit => 'WARNING', $ok_exit => 'OK');

sub help {
    print <<EOT;
"USAGE: $0 <monitoring thresholds> | (-h)"
    -o,--tps_w    ==> Transactions per second, warning
    -p,--tps_c    ==> Transactions per second, critical
    -q,--brs_w    ==> Bytes read per second, warning
    -r,--brs_c    ==> Bytes read per second, critical
    -s,--bws_w    ==> Bytes written per second, warning
    -t,--bws_c    ==> Bytes written per second, critical
    -h,--help ==> Prints this message
Example:
    $0 --bws_w=1 --tps_w=1 --brs_c=1 --tps_c=1
EOT
    exit $unk_exit;
}

# Print help
if (defined $help){
    &help();
}

# Validate tools
my $iostat = "/usr/bin/iostat";

if (! -e $iostat){
    &end($unk_exit,'message',"$iostat command not found");
}

# Get results from iostat
my $results;
$results = `$iostat -d`;
my @iostat = split(/\n/, $results);

# Validate output
if (!$results){
    &end($crit_exit,'message',"Didn't get any results or is not in expected format");
}

# Remove the first 3 lines (kernel / system version, blanks, stat headers).
shift(@iostat);
shift(@iostat);
shift(@iostat);

my $exit_code;
my @values;
$exit_code = &threshold_check(@iostat);
&end($exit_code, 'result');

sub threshold_check {
    my @iostat = @_;
    my $flag;

    foreach (@iostat) {

        # Format result string
        my @array = split(/ /, $_);
        chomp(@array);
        @array = grep(/[a-z*\d+]/i,@array);
        
        # Store values
        $dev = $array[0];
        $tps = $array[1];
        $brs = $array[2];
        $bws = $array[3];
        $br = $array[4];
        $bw = $array[5];
        
        # Do not print total bytes / written
        push(@values, "$dev\_tps=$tps, $dev\_brs=$brs, $dev\_bws=$bws,");
        
        # Compare values
        if ((defined $tps_c) && ($tps > $tps_c)){
            $flag = $crit_exit;
        }
        elsif ((defined $tps_w) && ($tps > $tps_w)){
            $flag = $warn_exit;
        }
        elsif ((defined $brs_c) && ($brs > $brs_c)){
            $flag = $crit_exit;
        }
        elsif ((defined $brs_w) && ($brs > $brs_w)){
            $flag = $warn_exit;
        }
        elsif ((defined $bws_c) && ($bws > $bws_c)){
            $flag =  $crit_exit;
        }
        elsif ((defined $bws_w) && ($bws > $bws_w)){
            $flag = $warn_exit;
        }
    }
    if (!defined $flag) {
        $flag = $ok_exit;
    }
    return $flag;
}

# Print results
sub end{
    my ($exitcode,$type,$output) = @_ ;
    if ($type eq 'result') {
        print "Disk iostat $exit{$exitcode}, ", (defined $tps_w)?"tps_w=$tps_w, ":'', (defined $tps_c)?"tps_c=$tps_c, ":'', (defined $brs_w)?"brs_w=$brs_w, ":'', (defined $brs_c)?"brs_c=$brs_c, ":'', (defined $bws_w)?"bws_w=$bws_w, ":'', (defined $bws_c)?"bws_c=$bws_c, ":'';
        print "Processing " .scalar(@values) . " items | @values\n";
        exit $exitcode;
    }
    if ($type eq 'message') {
        print "Data check $exit{$exitcode}, $output\n";
        exit $exitcode;    
    }
}