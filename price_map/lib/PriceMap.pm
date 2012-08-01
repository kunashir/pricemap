package PriceMap;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::DigestAuth;

# This method will run once at server start
sub startup {
  my $self = shift;
  $self->plugin('digest_auth', allow => {'Admin' => {sshaw => 'mu_pass'}});
  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
