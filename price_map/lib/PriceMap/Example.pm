package PriceMap::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
	my $self = shift;
	$self->redirect_to('/login') and return 0 unless($self->is_user_authenticated);
	my $m = '';
	if ( not $self->is_user_authenticated ) {

        $m = "You must log in to view this page" ;

        #$self->redirect_to('/');
		
        #return;

	}
	else
    {
  #return unless $self->digest_auth(allow => {sshaw => 'mu_pass'});
  # Render template "example/welcome.html.ep" with message
		$m = "Welcome to the Mojolicious real-time web framework!";
	}
	$self->stash(ppp=>$m);
}

1;
