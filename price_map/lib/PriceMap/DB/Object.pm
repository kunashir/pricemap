package PriceMap::DB::Object;

use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

use PriceMap::DB::DB;
use base qw(Rose::DB::Object);

sub init_db{ PriceMap::DB::DB->new };

1;

