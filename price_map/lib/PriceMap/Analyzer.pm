use strict;
use warnings;
package PriceMap::Analyzer;
use Mojo::Base 'Mojolicious::Controller';

my $IMAGE_BASE = '/uploads';

sub upload {
    my $self = shift;

    # Uploaded image(Mojo::Upload object)
    my $image = $self->req->upload('image');
    
    # Not upload
    unless ($image) {
        return $self->render(
            template => 'error', 
            message  => "Upload fail. File is not specified."
        );
    }
    
    # Upload max size
    #my $upload_max_size = 3 * 1024 * 1024;
    
    # Over max size
    #if ($image->size > $upload_max_size) {
    #    return $self->render(
    #        template => 'error',
     #       message  => "Upload fail. Image size is too large."
     #   );
    #}
    
    # Check file type
    #my $image_type = $image->headers->content_type;
    #my %valid_types = map {$_ => 1} qw(image/gif image/jpeg image/png);
    
    ## Content type is wrong
    #unless ($valid_types{$image_type}) {
        #return $self->render(
            #template => 'error',
            #message  => "Upload fail. Content type is wrong."
        #);
    #}
    
    # Extention
    #my $exts = {'image/gif' => 'gif', 'image/jpeg' => 'jpg',
                #'image/png' => 'png'};
    #my $ext = $exts->{$image_type};
    
    # Image file
    my $full_path = "uploads/".$image->filename;
	print $full_path;
	print $image->filename;
    #open (CURFILE, ">$full_path") or die "Can't open/create file $full_path";
    #close (CURFILE);
    my $image_file = $full_path; #"$IMAGE_BASE/" . $image->filename;
    
    # If file is exists, Retry creating filename
    while(-f $image_file){
        $image_file = $full_path; #"$IMAGE_BASE/" . $image->filename;
    }
    
    # Save to file
    $image->move_to($image_file);
    
    # Redirect to top page
    $self->redirect_to('index');
};

sub upload_form {
	my $self = shift;
}
1;
