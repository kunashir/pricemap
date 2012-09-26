package PriceMap::Usercontroller;
use Mojo::Base 'Mojolicious::Controller';

use PriceMap::DB::User;
use PriceMap::DB::User::Manager;

use Data::Dumper;

use Encode;
#use Lingua::DetectCharset;
#use Convert::Cyrillic;
use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

use strict;
use warnings; 


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
	#my $cur_user = $self->app->session->data('user_id');
	my $users = PriceMap::DB::User::Manager->get_users();
	my $list_users = [];
	for my $cur_user (@$users)
	{
		my $cur_hash_data = {user_id => $cur_user->{user_id}, name => $cur_user->name_utf, email => $cur_user->{email}, company => $cur_user->{company}};
		push $list_users, $cur_hash_data;
	}

	my $total_pages = 10;
    my $records = scalar @$list_users;
    print "limit->", $limit;
    if( $limit ) 
    { 
        $total_pages = int((scalar @$list_users)/($limit)) || 1; 
    } 
    my $start_index = ($page -1 )*$limit;
    my $end_index = $page*$limit;
    if ($records <= $end_index)
    {
        $end_index = $records - 1;
    }
    my $result = {page => $page, total => $total_pages, records => $records , rows => $list_users};#, rows => @$rows[$start_index..$end_index]};
	
	return $self->render(
        json => $result
        );
}

1;