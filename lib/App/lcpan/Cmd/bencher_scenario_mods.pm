package App::lcpan::Cmd::bencher_scenario_mods;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'List all Bencher::Scenario::* modules',
    description => <<'_',

This is just a shortcut for:

    % lcpan mods --namespace Bencher::Scenario

_
    args => {
        %App::lcpan::common_args,
        %App::lcpan::detail_args,
    },
};
sub handle_cmd {
    my %args = @_;
    App::lcpan::modules(%args, namespaces => ['Bencher::Scenario']);
}

1;
# ABSTRACT:
