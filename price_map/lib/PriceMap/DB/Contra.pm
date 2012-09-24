package PriceMap::DB::Contra; 

use Encode;
#use Lingua::DetectCharset;
#use Convert::Cyrillic;
use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

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

sub name_utf {
  my $self = shift;#$_[0]; 
  my $new_name = shift;#$_[1];
  if ($new_name) #работаем как сеттор
  {
    $new_name = encode("utf8", $new_name);
    return $self->name($new_name);
  }
  else
  {
    return decode("utf8", $self->name());
  }
}
    1;