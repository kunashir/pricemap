package PriceMap::DB::User; 

use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

use base 'PriceMap::DB::Object';

use strict;
use warnings;




__PACKAGE__->meta->setup
    (
      table      => 'user',
      columns    => [ qw(user_id user_name user_passwd) ],
      pk_columns => 'user_id',
      unique_key => 'user_name',
    );

1; 
