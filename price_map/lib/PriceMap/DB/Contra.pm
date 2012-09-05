package PriceMap::DB::Contra; 

use base 'PriceMap::DB::Object';

use PriceMap::DB::User;
use strict;
use warnings;




__PACKAGE__->meta->setup
    (
      table      => 'contra',
      columns    => [ qw(id name email price_path user_id) ],
      pk_columns => 'id',
      unique_key => 'name',
      foreign_keys => [
      	user => {
      		class => 'User',
      		key_columns => { user_id => 'user_id'}
      	}
      ]
    );

    1;