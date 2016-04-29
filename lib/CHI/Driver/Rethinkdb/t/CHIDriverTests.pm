package CHI::Driver::Rethinkdb::t::CHIDriverTests;
use strict;
use warnings;
use CHI::Test;
use base qw(CHI::t::Driver);

sub testing_driver_class { 'CHI::Driver::Rethinkdb' }
sub supports_get_namespaces { 0 }

sub new_cache_options {
    my $self = shift;

    return (
        $self->SUPER::new_cache_options(),
    );

}

sub test_multiple_processes { }


1;

