package PriceMap::Session;
use Mojo::Base 'Mojolicious::Controller';

sub  signup {
	my $self = shift;

	my $user = $self->param('name');
    #my $pass = $self->param('pass') || q{};
	print $user;
	my $crypted_pass = $self->bcrypt( $self->param('pass') );
	my $sth = $self->db->prepare('INSERT INTO user (user_name, user_passwd) VALUES (?, ?)');

    $sth->execute($user, $crypted_pass);

    if ( my $res = $sth->fetchrow_hashref ) {
			$self->flash( message => 'Sign up success!' );

			$self->redirect_to('/');
            #return $res;
        }
    else {
			$self->flash( message => 'Sign up error!' );
            return;
        }
}; 


sub logout {

    my $self = shift;

    $self->session( expires => 1 );

    $self->redirect_to('/');

};

sub  login {

    my $self = shift;

    my $user = $self->param('name') || q{};

    my $pass = $self->param('pass') || q{};

    if ( $self->authenticate( $user, $pass ) ) {

        $self->redirect_to('/welcome');

    }
    else {

        $self->flash( message => 'Invalid credentials!' );

        $self->redirect_to('/');

    }

}
1;
