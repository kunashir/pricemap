package PriceMap::Example;
use Mojo::Base 'Mojolicious::Controller';
use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

# This action will render a template
sub welcome {
	my $self = shift;
	$self->redirect_to('/login') and return 0 unless($self->is_user_authenticated);
	my $m = '';
	if ( not $self->is_user_authenticated ) {

        $m = "Для просмотра старницы вы должны войти/зарегистрироваться" ;

        #$self->redirect_to('/');
		
        #return;

	}
	else
    {
  #return unless $self->digest_auth(allow => {sshaw => 'mu_pass'});
  # Render template "example/welcome.html.ep" with message
		$m = "Добро пожаловать, в Анализ прайсов!";
	}
	$self->stash(ppp=>$m);
}

1;
