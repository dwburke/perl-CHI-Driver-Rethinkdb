#!/usr/bin/env perl
use strict;
use JSON;

use DBURKE::Rethink;
use DBURKE::Toolbox::Time;
use CHI;

my $cache = CHI->new(
    driver => 'Rethinkdb',
    #create_table => 1,
    db_name => 'dev',
    namespace => 'efdsa',
    );

print "outside: _table: " . $cache->_table . "\n";

my $tt = DBURKE::Toolbox::Time->new;

my @keys;

@keys = $cache->get_keys;
print "get_keys 1: " . to_json(\@keys, { pretty=>1, canonical=>1 }) . "\n";

$cache->set("k-one", "key one $$", "3 seconds");
$cache->set("k-two", "key two $$");

@keys = $cache->get_keys;
print "get_keys 2: " . to_json(\@keys, { pretty=>1, canonical=>1 }) . "\n";
#show_all();

print "k-one: '" . $cache->get("k-one") . "'\n";
print "k-two: '" . $cache->get("k-two") . "'\n";

$cache->remove("k-two");

print "k-one: '" . $cache->get("k-one") . "'\n";
print "k-two: '" . $cache->get("k-two") . "'\n";

sleep 4;

#show_all();

print "k-one: '" . $cache->get("k-one") . "'\n";
print "k-two: '" . $cache->get("k-two") . "'\n";

exit(0);

sub show_all {
my $ckeys = $cache->r->table( $cache->_table )->run;
print to_json($ckeys->response, { pretty=>1, canonical=>1 }) . "\n";
}


#$tt->start;
#my $r = DBURKE::Rethink->new(dbname => 'test2');
#$tt->stop;
#$r->db('test2')->table_create('cache23')->run;


#for (my $i = 0; $i < 100; $i++) {
#$tt->start('insert');
#my $x = $r->table('player2')->insert({
    #name => 'HI!' . $i
    #})->run;
#$tt->stop('insert');
#
#print $x->response . "\n";
#$tt->start('wait');
#$r->wait->run;
#$tt->stop('wait');
#}



#print "creating test2:\n";
#my $ret = $rethink->db_create('test2')->run;
#print "done\n";
#print to_json($ret->response);

#my $r = $rethink->rr;
#$rethink->rio->repl;
#my $x = $r->db_create('dev')->run;
#print $x->response;
