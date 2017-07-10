package App::lcpan::Cmd::bencher_scenarios_for_mod;

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
    summary => 'List Bencher::Scenario::* modules related to specified module',
    args => {
        %App::lcpan::common_args,
        %App::lcpan::mod_args,
        %App::lcpan::detail_args,
    },
};
sub handle_cmd {
    my %args = @_;
    my $mod = $args{module};

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $res = App::lcpan::rdeps(%args, modules => [$mod], rel => 'x_benchmarks', phase => 'x_benchmarks');
    return $res if $res->[0] != 200;
    return [200, "OK", []] unless @{ $res->[2] };

    my @mods;
    my $sth = $dbh->prepare(
        "SELECT m.name AS module, d.name AS dist, m.abstract AS abstract FROM module m JOIN dist d ON m.file_id=d.file_id".
            " WHERE d.name IN (".
                join(",", map {$dbh->quote($_->{dist})} @{ $res->[2] }).")");
    $sth->execute;
    my @rows;
    my $resmeta = {};
    $resmeta->{'table.fields'} = [qw/module dist abstract/] if $args{detail};
    while (my $row = $sth->fetchrow_hashref) {
        next unless $row->{module} =~ /^Bencher::Scenario::/;
        if ($args{detail}) {
            push @rows, $row;
        } else {
            push @rows, $row->{module};
        }
    }

    [200, "OK", \@rows, $resmeta];
}

1;
# ABSTRACT:
