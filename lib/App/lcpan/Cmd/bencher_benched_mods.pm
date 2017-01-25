package App::lcpan::Cmd::bencher_scenario_for_mod;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::Any::IfLOG '$log';

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'List all modules that are participants in at least one Bencher::Scenario::* module',
    args => {
        %App::lcpan::common_args,
        %App::lcpan::detail_args,
    },
};
sub handle_cmd {
    my %args = @_;
    my $mod = $args{module};

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $res = App::lcpan::modules(%args, namespaces => ['Bencher::Scenario']);
    return $res if $res->[0] != 200;
    return [200, "OK", []] unless @{ $res->[2] };

    App::lcpan::deps(%args, modules => $res->[2], rel => 'x_benchmarks', phase => 'x_benchmarks', flatten => 1);
}

1;
# ABSTRACT:
