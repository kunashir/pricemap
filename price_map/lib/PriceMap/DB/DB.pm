package PriceMap::DB::DB; 

use strict;
use warnings;

use base qw/Rose::DB/;
#our @ISA = qw(Rose::DB);

#use AptekaNavigator;
#my $dummy = AptekaNavigator->new;
#die $dummy->app->home;

#my $dummy = Mojolicious::Controller->new;

__PACKAGE__->use_private_registry;
__PACKAGE__->register_db(
    driver          => 'SQLite',
    database        => 'auth.db',
    username        => '',
    password        => ''
);

#undef $dummy;

#AptekaNavigator::DB::DB->default_domain('172.13.0.1');
#AptekaNavigator::DB::DB->default_type('session');

1;

