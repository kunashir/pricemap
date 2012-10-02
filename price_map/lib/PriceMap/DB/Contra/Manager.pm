package  PriceMap::DB::Contra::Manager;

use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

use base qw/Rose::DB::Object::Manager/;
use Data::Dumper;

 sub object_class { 'PriceMap::DB::Contra' };

__PACKAGE__->make_manager_methods('contras');

sub select_tag_data
{
	my $self = shift;
	my $cur_user = shift;
	my $contras = $self->get_contras(
		 query => [
		 	user_id => $cur_user
		 	]
	);
	my $list_contras = [['Выберите поставщика' => -1]];
	for my $cur_contra (@$contras)
	{
		my $cur_hash_data = [$cur_contra->name_utf => $cur_contra->id];
		push $list_contras, $cur_hash_data;
	}
	print Dumper $list_contras;
	return $list_contras;
}

1;
