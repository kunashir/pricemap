# Sample schema:
# CREATE TABLE user (user_id integer primary key,
# user_name varchar,
# user_passwd varchar);
#
package PriceMap;
use Mojo::Base 'Mojolicious';
#use Mojolicious::Plugin::DigestAuth;
use Mojolicious::Plugin::Authentication;
use Mojolicious::Plugin::Bcrypt;
use Mojolicious::Plugin::Database;
use DBI;
use Mojo::Upload;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::FmtUnicode;


# This method will run once at server start
sub startup {
  my $self = shift;
  #$self->plugin('digest_auth', allow => {'Admin' => {sshaw => 'mu_pass'}});
  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

	$self->plugin( 'database' => {
		dsn => 'dbi:SQLite:dbname=auth.db',
		username => q{},
		password => q{},
		options => { RaiseError => 1 },
		helper => 'db',

	});

#
# Use strong encryption
#

	$self->plugin('bcrypt');

#
# Database-based authentication example
#

	$self->plugin ('authentication' => {

    load_user => sub {

        my ( $self, $uid ) = @_;

        my $sth = $self->db->prepare(' select * from user where user_id=? ');

        $sth->execute($uid);

        if ( my $res = $sth->fetchrow_hashref ) {

            return $res;

        }
        else {

            return;
        }

    },

    validate_user => sub {

        my ( $self, $username, $password ) = @_;

        my $sth
            = $self->db->prepare(' select * from user where user_name = ? ');

        $sth->execute($username);

        return unless $sth;

        if ( my $res = $sth->fetchrow_hashref ) {

            my $salt = substr $password, 0, 2;

            if ( $self->bcrypt_validate( $password, $res->{user_passwd} ) ) {

                $self->session(user => $username);

                #
                # For data that should only be visible on the next request, like
                # a confirmation message after a 302 redirect, you can use the
                # flash.
                #
                
                $self->flash(message => 'Thanks for logging in.');

                return $res->{user_id};

            }
            else {

                return;

            }

        }
        else {

            return;

        }
    },

});


  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->get('/login_form')->to('session#login_form');
  $r->any('/login')->to('session#login');
  $r->get('/logout')->to('session#logout');
  $r->get('/signup')->to('session#signup');
  $r->get('/signup_form')->to('session#signup_form');
  $r->get('/upload_form')->to('analyzer#upload_form');
  $r->any('/upload')->to('analyzer#upload');
  $r->any('/show_file')->to('analyzer#show_file');
}

1;
