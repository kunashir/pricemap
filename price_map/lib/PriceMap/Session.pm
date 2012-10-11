package PriceMap::Session;
use Mojo::Base 'Mojolicious::Controller';
use encoding 'utf8'; #чтобы текст понимался русский
use utf8;


sub  signup {
	my $self = shift;

	my $user = $self->param('name');
    my $pass = $self->param('pass');
    my $email = $self->param('email');
    my $company = $self->param('company');
	
    if (!$user or !$pass)
    {
        $self->flash(message => 'Ни Пароль ни логин не могут быть пустыми!');
        $self->redirect_to('/signup_form');
        return;
    }
    if (!$email)
    {
        $self->flash(message => 'Заполните поле e-mail!');
        $self->redirect_to('/signup_form');
        return;   
    }

	my $crypted_pass = $self->bcrypt( $self->param('pass') );
	my $sth = $self->db->prepare('INSERT INTO user (user_name, user_passwd, email) VALUES (?, ?, ?, ?)');

    if ($sth->execute($user, $crypted_pass, $email, $company)) {

    #if ( my $res = $sth->fetchrow_hashref ) {
			$self->flash( message => 'Вы успешно зарегистрированы!' );
			
			$self->login($user, $self->param('pass'));
			$self->redirect_to('/');
            #return $res;
        }
    else {
			$self->flash( message => 'Ошибка регистрации!' );
            return;
        }
}; 


sub logout {

    my $self = shift;

    $self->session( expires => 1 );
    $self->app->session->data('user_id', '');
    $self->app->session->flush;

    $self->redirect_to('/');

};

sub  login_form {
	my $self = shift;
};

sub  signup_form {
	my $self = shift;
};

sub  login {

    my $self = shift;

    print "IN LOGIN SUB";
    my $user = $self->param('name');

    my $pass = $self->param('pass');

    if ( $self->authenticate( $user, $pass ) ) {

        print "USER_ID".$self->app->session->data('user_id');
        $self->redirect_to('/');
        

    }
    else {

        $self->flash( message => 'Ошибка входа!' );

        $self->redirect_to('/login_form');

    }

}

sub is_login {
    my $self = shift;
    print "USER_ID in check:".$self->app->session->data('user_id');
    if ($self->app->session->data('user_id'))
    {
        return 1;
    }
    else
    {
        $self->flash( message => 'Войдите для доступа к данной функции!' ); 
        $self->redirect_to('/login_form');
    } 
}
1;
