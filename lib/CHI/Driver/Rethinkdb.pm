package CHI::Driver::Rethinkdb;

use Moose;
use Moose::Util::TypeConstraints;
use Carp qw(croak);

use DBURKE::Rethink;

extends 'CHI::Driver';


#    my $cache = CHI->new(
#        driver         => 'Rethinkdb',
#        port
#        db
#    );

# TODO - refactor this
has r => (is => 'ro', isa  => 'DBURKE::Rethink', lazy => 1, builder => '_build_r' );
sub _build_r {
    my $self = shift;
    DBURKE::Rethink->new(dbname => $self->db_name);
}

has '+max_key_length'   => ( default => sub { 120 } );
has db_name      => ( is => 'rw', isa => 'Str', default => sub { 'test2' } );
has table_prefix => ( is => 'rw', isa => 'Str', default => sub { 'chi_' } );


__PACKAGE__->meta->make_immutable;

sub _table {
    my ($self) = @_;
    return $self->table_prefix . $self->namespace();
}


sub BUILD {
    my ( $self, $args ) = @_;

    my $r = $self->r;
    my $response = $r
        ->db( $self->db_name )
        ->table_create( $self->_table )
        ->run;

    if ($response && $response->type > 5) {
        unless ($response->response->[0] =~ /already exists/i) {
            croak $response->response->[0]  . '(' . $response->type . ')';
        }
    }

    return;
}

sub fetch {
    my ( $self, $key ) = @_;

    my $response = $self->r->table( $self->_table )->get( $key )->run;

    if ($response->type > 5) {
        croak $response->response->[0]  . '(' . $response->type . ')';
    }

    if (my $data = $response->response) {
        return $data->{data};
    }

}

sub store {
    my ($self, $key, $data) = @_;

    my $response = $self->r->table( $self->_table )->get( $key )->replace({
        id => $key,
        data => $data
        })->run;
    if ($response->type > 5) {
        croak $response->response->[0]  . '(' . $response->type . ')';
    }

    return;
}

sub remove {
    my ( $self, $key ) = @_;

    my $response = $self->r->table( $self->_table )->get( $key )->delete->run;

    if ($response->type > 5) {
        croak $response->response->[0]  . '(' . $response->type . ')';
    }

    return;
}

sub clear {
    my ($self) = @_;

    my $response = $self->r->table( $self->_table )->delete->run;

    if ($response->type > 5) {
        croak $response->response->[0]  . '(' . $response->type . ')';
    }

    return;
}

sub get_keys {
    my ($self) = @_;

    my $response = $self->r->table( $self->_table )->run;

    if ($response->type > 5) {
        croak $response->response->[0]  . '(' . $response->type . ')';
    }

    my @keys = map { $_->{id} } @{ $response->response };
    return @keys;
}

sub get_namespaces {
    croak 'not supported';
}

1;

