package CHI::Driver::Rethinkdb;

use Moose;
use Moose::Util::TypeConstraints;
use CHI::Driver;

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
    DBURKE::Rethink->new(dbname => 'test2'); # get this from args somehow
}

has db_name      => ( is => 'rw', isa => 'Str', default => sub { 'test2' } );
has table_prefix => ( is => 'rw', isa => 'Str', default => sub { 'chi_' } );


__PACKAGE__->meta->make_immutable;

sub _table {
    my ($self) = @_;
    return $self->table_prefix . $self->namespace();
}


sub BUILD {
    my ( $self, $args ) = @_;

    if ( $args->{create_table} ) {

	print "table_prefix: " . $self->table_prefix . "\n";
	print "_table: " . $self->_table . "\n";
        my $r = $self->r;
        my $response = $r
            ->db( $self->db_name )
            ->table_create( $self->_table )
            ->run;
    
        if ($response && $response->type > 5) {
            die $response->response->[0];
        }
    }

    return;
}

sub fetch {
    my ( $self, $key ) = @_;

}

sub store {
    my ($self, $key, $data) = @_;
    my $response = $self->r->table( $self->_table )->insert({
        key => $key,
        data => $data
        })->run;
    if ($response->type > 5) {
        die $response->response;
    }

}

sub remove {
    my ( $self, $key ) = @_;

}

sub clear {
    my ($self) = @_;

}

sub get_keys {
    my ($self) = @_;

}

sub get_namespaces {
    my ($self) = @_;

}

1;

