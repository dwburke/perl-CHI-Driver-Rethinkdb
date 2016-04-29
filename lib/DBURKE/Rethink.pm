package DBURKE::Rethink;

use Moose;
use Rethinkdb;
use Rethinkdb::IO;

has rio => ( is => 'rw', isa => 'Rethinkdb::IO', lazy => 1, builder => '_build_rio' );
has dbname => ( is => 'rw', isa => 'Str', default => 'test' );

sub _build_rio {
    my $self = shift;
    my $io = Rethinkdb::IO->new;
    $io->port(32769);
    $io->default_db($self->dbname);
    $io->connect->repl;
    $io;
}

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift;

    my $name = $AUTOLOAD;
    $name =~ s/.*://;
    return if $name eq 'DESTROY';

    $self->rio;

    r->$name(@_);
}


1;

