package  PriceMap::DB::User::Manager;

use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

use base qw/Rose::DB::Object::Manager/;
use Data::Dumper;

 sub object_class { 'PriceMap::DB::User' };

__PACKAGE__->make_manager_methods('users');


1;
