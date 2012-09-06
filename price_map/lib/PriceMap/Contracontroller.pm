package PriceMap::Contracontroller;
use Mojo::Base 'Mojolicious::Controller';
use PriceMap::DB::Contra::Manager;
use PriceMap::DB::Contra;

use Data::Dumper;

use strict;
use warnings;

sub index {
	
}

sub operations_contra {
    my $self = shift;
    my $params = $self->req->body_params->to_hash();
    my $cur_con = PriceMap::DB::Contra->new(id => $params->{'id'});
    $cur_con->load;
    $cur_con->name($params->{'name'});
    $cur_con->email($params->{'email'});
    $cur_con->price_path($params->{price_path});
    if ($cur_con->save)
    {
        $self->render(
        json => {success => 'Сохранено!'});
    }
    else
    {
        $self->render(
        json => {error => 'Произошла ошибка при сохранении изменений!'});
    }

}

sub get_index {

	my $self = shift;

	my $POST = $self->req->body_params->to_hash();
    my $GET = $self->req->query_params->to_hash();
    my $params;
   # print Dumper $GET;
    if (scalar keys $GET > 0) {
        $params = $GET;
    } elsif (scalar keys $POST > 0) {
        $params = $POST;
    } else {
        $params = {};
    }

    my $page = $params->{'page'} || 1; # get the requested page 
    my $limit = $params->{'rows'}|| 20; # get how many rows we want to have into the grid 
    my $sidx = $params->{'sidx'}; # get index row - i.e. user click to sort 
    my $sord = $params->{'sord'}; # get the direction

	#my $output_text = "";
	my $cur_user = $self->app->session->data('user_id');
	my $contras = PriceMap::DB::Contra::Manager->get_contras(
		# query => [
		# 	user_id => $cur_user
		# 	]
		);
	my $list_contras = [];
	for my $cur_contra (@$contras)
	{
		my $cur_hash_data = {id => $cur_contra->{id}, name => $cur_contra->{name}, email => $cur_contra->{email}, price_path => $cur_contra->{price_path}};
		push $list_contras, $cur_hash_data;
	}

	my $total_pages = 10;
    my $records = scalar @$list_contras;
    print "limit->", $limit;
    if( $limit ) 
    { 
        $total_pages = int((scalar @$list_contras)/($limit)) || 1; 
    } 
    my $start_index = ($page -1 )*$limit;
    my $end_index = $page*$limit;
    if ($records <= $end_index)
    {
        $end_index = $records - 1;
    }
    my $result = {page => $page, total => $total_pages, records => $records , rows => $list_contras};#, rows => @$rows[$start_index..$end_index]};
	print Dumper $contras;
	return $self->render(
        json => $result
        );
}

1;
 