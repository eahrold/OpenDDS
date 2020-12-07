eval '(exit $?0)' && eval 'exec perl -S $0 ${1+"$@"}'
     & eval 'exec perl -S $0 $argv:q'
     if 0;

# -*- perl -*-

use lib "$ENV{ACE_ROOT}/bin";
use lib "$ENV{DDS_ROOT}/bin";
use PerlDDS::Run_Test;
use strict;
use warnings;

PerlDDS::add_lib_path('../ConsolidatedMessengerIdl');

my $result = 0;
my $dcps_debug_lvl = 1;

sub runTest {
    my $delay = shift;

    my $test = new PerlDDS::TestFramework();
    $test->enable_console_logging();

    print "*********************************\n";
    print "DomainRangeTest creates a single process with 1 DW and 4 DRs.\n\n";
    print "Domains and transports are dynamically configured from the \n";
    print "templates in config.ini. The DW in each domain sends 10 \n";
    print "messages to its DRs.\n";
    print "*********************************\n";

    $test->process("alpha", 'DomainRangeTest', "-DCPSConfigFile config.ini -DCPSDebugLevel $dcps_debug_lvl -domain 2 -domain 10 -domain 20 -domain 50");

    $test->start_process("alpha");

    sleep $delay;

    my $res = $test->finish(150);
    if ($res != 0) {
        print STDERR "ERROR: test returned $res\n";
        $result += $res;
    }
}

runTest(0);

exit $result;
