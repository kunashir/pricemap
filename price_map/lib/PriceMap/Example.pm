package PriceMap::Example;
use Mojo::Base 'Mojolicious::Controller';
use Encode;
#use Lingua::DetectCharset;
#use Convert::Cyrillic;
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
		$m = "Добро пожаловать,";
	}
	$self->stash(ppp=>$m);
}


sub feedback {
	my $self = shift;
	my $data = $self->req->body;

	$self->stash(body=>decode("utf8",$data));
	my $letter_data = $self->render_mail('example/feedback');
	$self->render($self->mail(
                mail => {
                To      => 'support@apteka-s.ru',
                Subject => 'Fuck!' ,
                Data    => $letter_data,
                }
            )
        );
	 $self->render(
       text => "<p><b>Спасибо, Ваше письмо для нас ценно!</b></p>"
    );
}
1;
