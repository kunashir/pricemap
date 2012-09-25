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
use Mojolicious::Plugin::Mail;
use DBI;
use Mojo::Upload;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::FmtUnicode;
use MojoX::Session;
use MojoX::Session::Store::Dbi;
use MojoX::Session::Store::File;
use PriceMap::DB::Contra;

#Singleton Mojox::Session
my $_session;

sub session{

  my $app = shift;
  $Storable::Deparse = $Storable::Eval = 1; 
  unless(defined $_session)
  {
    $_session = MojoX::Session->new(
      #store     => MojoX::Session::Store::Dbi->new(dbh  => My::DB->new->dbh),
      store     => MojoX::Session::Store::File->new( dir => File::Spec->catfile($app->home, 'data' , 'session')), 
      #store     => Life25::MojoX::Session::Store::Dummy->new,
      transport => MojoX::Session::Transport::Cookie->new,
      ip_match  => 1,
      expires_delta => 3600,
      
    );
    $_session->expires(3600);
  }

  return $_session;
}


# This method will run once at server start
sub startup {
  my $self = shift;
  $self->secret("sEcrEt"); 
  $self->helper(is_login => sub {
    shift->app->session->data('user_id') ? 1 : 0;
    });

  # my $c = PriceMap::DB::Contra->new(id => 1, name => 'stupid contra');
  # $c->save;
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
#Init mail plugin
#
    my $conf = {
    from     => 'korolev@apteka-s.ru',
    encoding => 'base64',
    type     => 'text/html',
    how      => 'smtp',
    #howargs  => [ 'srv-mail', AuthUser=>'robot', AuthPass => 'hl7kx4v']
    howargs  => [ 'smtp.yandex.ru', AuthUser=>'korolev@apteka-s.ru', AuthPass => 'futurama']
  };
  $self->plugin(mail => $conf);

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
                $self->app->session->data('user_id', $res->{user_id});
                $self->app->session->flush;
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
  
  my $ra = $r->bridge('/analyzer')->to('session#is_login');
  $ra->route('/upload_form')->via('get')->to('analyzer#upload_form')->name("upload_form");
  $ra->route('/upload')->via('post')->to('analyzer#upload')->name("upload");
  $ra->route('/show_file')->via('get')->to('analyzer#show_file')->name("show_file");
  $ra->route('/get_data')->via('get')->to('analyzer#get_data')->name("get_data");
  $ra->route('/cons_order')->via('get')->to('analyzer#cons_order')->name("cons_order");
  $ra->route('/order')->via('get')->to('analyzer#order')->name("order");
  $ra->route('/save_changes')->via('post')->to('analyzer#save_changes')->name("save_changes");
  $ra->route('/del_all')->via('post')->to('analyzer#del_all')->name("del_all");
  
  
  #contra
  my $rn = $r->bridge('/contras')->to('session#is_login');
  $rn->route('/index')->via('get')->to('contracontroller#index')->name('contra_index');
  #$rn->route->via('get')->to('contracontroller#get_index')->name('contras');
  $rn->route('/get_index')->via('get')->to('contracontroller#get_index');
  #$r->any('/get_index')->to('contracontroller#get_index');
  $rn->route('/operations')->via('post')->to('contracontroller#operations_contra');
  #Set server-storable session
  $self->hook(before_dispatch => sub {
    my $c = shift;

    #$c->stash('Mii.started' => time);


    my $s = $c->app->session;   

    $s->tx($c->tx);

    $s->create unless $s->load;
    
    $c->app->log->info('----------- sid = '. $s->sid . ' path = ' . $c->req->url);
    
    $s->extend_expires; 
    $s->flush;

    ##return if $c->stash('mojo.static');
    ###return if $c->req->content->headers->content_type !~ /html/i;
    ###return unless defined $c->res->dom->at('html');



    ##my $key = sha1_sum($c->req->url->to_abs);

    ##$DB::single = 1;

    ##if(defined (my $val = $c->app->cache->get($key)))
    ##{
      ##$c->stash('Mii.cached' => 1);
      ##$c->render_data($val);

     ##}
     ##my $tst = 1;

  });
}

1;
