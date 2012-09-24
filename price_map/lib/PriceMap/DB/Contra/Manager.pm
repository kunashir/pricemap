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
	my $contras = $self->get_contras();
	my $list_contras = [];
	for my $cur_contra (@$contras)
	{
		my $cur_hash_data = [$cur_contra->name_utf => $cur_contra->id];
		push $list_contras, $cur_hash_data;
	}
	print Dumper $list_contras;
	return $list_contras;
}

1;
