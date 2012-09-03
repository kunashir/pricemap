package PriceMap::DB::Contra; 

use base 'PriceMap::DB::Object';

use strict;
use warnings;




__PACKAGE__->meta->setup
    (
      table      => 'contra',
      columns    => [ qw(id name email price_path ) ],
      pk_columns => 'id',
      unique_key => 'name',
    );

    1;