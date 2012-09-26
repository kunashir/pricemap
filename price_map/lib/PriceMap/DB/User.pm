package PriceMap::DB::User; 

use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

use base 'PriceMap::DB::Object';

use Encode;

use strict;
use warnings;




__PACKAGE__->meta->setup
    (
      table      => 'user',
      columns    => [ qw(user_id user_name user_passwd email company) ],
      pk_columns => 'user_id',
      unique_key => 'user_name',
    );

sub name_utf {
  my $self = shift;#$_[0]; 
  my $new_name = shift;#$_[1];
  if ($new_name) #работаем как сеттор
  {
    $new_name = encode("utf8", $new_name);
    return $self->user_name($new_name);
  }
  else
  {
    return decode("utf8", $self->user_name());
  }
}

1; 
