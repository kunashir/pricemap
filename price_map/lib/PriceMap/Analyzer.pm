use strict;
use warnings;
package PriceMap::Analyzer;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use Encode;
use Lingua::DetectCharset;
use Convert::Cyrillic;


my $IMAGE_BASE = '/uploads';


sub parser_excel {

    my $self    = shift;

    print "paser work!";
    my $filename = shift; # имя файла, который будем парсить
    # Создаем объект-парсер
    my $oExcel  = new Spreadsheet::ParseExcel;
    # code page
    my $oFmtR   = Spreadsheet::ParseExcel::FmtUnicode->new(Unicode_Map => "CP1251");

    my $oBook   = $oExcel->Parse($filename, $oFmtR);
    # choice sheet
    my $oWks    = $oBook->{Worksheet}[0];
    my $headr_find  = 0;

    $self->session('price_map'=> {}); #создадим в сессиях хеш 

    my %header_hash = ();

    for (my $i = 0; $i <= 20 ; $i++) #$oWks->{20}
    {
        my $is_header = 0;
        for (my $j = 0; $j <= 200; $j++)
        {
            my $cur_val = $oWks->{Cells}[$i][$j];
            if (!$headr_find && $cur_val)
            {
                #my $val = $cur_val->Value;
                my $val = decode('cp1251', $cur_val->Value);
                $header_hash{$j} = $val;
                $self->session('price_map')->{$val} = [];
                $is_header = 1;
            }
            elsif ($headr_find && $cur_val) 
            {
                 push $self->session('price_map')->{$header_hash{$j}}, $cur_val->Value;
            }
        }
        if ($is_header)
        {
            $headr_find = 1;

        }

    }
};

sub show_file {
    print "show file work!";
    my $self = shift;
    my $tr = "<tr>";
    my $end_tr = "</tr>";
    my $td = "<td>";
    my $end_td = "</td>";
    my $dd = $tr;
    #print Dumper $self->session('price_map');
    my @keys_hash = keys $self->session('price_map');
    print Dumper @keys_hash;
    foreach  my $key (@keys_hash) {
        $dd .= $td.$key.$end_td;
    }

    # for ((my $key, my $value) = each($self->session('price_map')))
    # {
    #     my $value = $self->session('price_map')->{$key};
    #     $dd .= $td.$key.$end_td;
    # }

    $dd .= $end_tr;

    $self->stash( data_table => $dd);

}

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
    #while(-f $image_file){
    #    $image_file = $full_path; #"$IMAGE_BASE/" . $image->filename;
    #}
    
    # Save to file
    $image->move_to($image_file);
    
    $self->parser_excel($image_file);

    # Redirect to top page
    $self->redirect_to('show_file');
};

sub upload_form {
	my $self = shift;
}
1;
