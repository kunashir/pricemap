package PriceMap::ContraController;
use Mojo::Base 'Mojolicious::Controller';
use PriceMap::DB::Contra::Manager;
use PriceMap::DB::Contra;


use strict;
use warnings;

sub index {

	my $self = shift;
	my $output_text = "";
	my $contra_interator = PriceMap::DB::Contra::Manager->get_products_iterator;
	while (my $cur_contra = $contra_interator ) {
		$output_text .= "<li>".$cur_contra->name.";e-mail:".$cur_contra->email."</li><br>";
	}

}

1;
 
