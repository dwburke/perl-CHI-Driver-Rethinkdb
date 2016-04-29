#!perl -w
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use CHI::Driver::Rethinkdb::t::CHIDriverTests;
CHI::Driver::Rethinkdb::t::CHIDriverTests->runtests;
