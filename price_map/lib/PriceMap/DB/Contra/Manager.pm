package  PriceMap::DB::Contra::Manager;

use base qw/Rose::DB::Object::Manager/;

 sub object_class { 'PriceMap::DB::Contra' };

__PACKAGE__->make_manager_methods('contras');

1;
