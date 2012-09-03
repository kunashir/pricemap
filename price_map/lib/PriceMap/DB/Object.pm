package PriceMap::DB::Object;

use PriceMap::DB::DB;
use base qw(Rose::DB::Object);

sub init_db{ PriceMap::DB::DB->new };

1;

