use strict;
use warnings;
package PriceMap::Analyzer;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use Encode;
#use Lingua::DetectCharset;
#use Convert::Cyrillic;
use encoding 'utf8'; #чтобы текст понимался русский
use utf8;

my $IMAGE_BASE = '/uploads';

#Формирование данных прайсов в формате json для
#jqGride. Формат ответа:
#Хеш вида: {
#            page => 1,
#            total => 1,
#            records => scalar keys $list,
#            rows => $list }
# причем $list - это тоже хеш { id => '', row => [это уже массив со значениями]]}
#
#
sub get_data {

};

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
    my $headr_find      = 0;
    
    my $my_data = [];
    my %header_hash = ();

    my $find_row_nom    = 0;
    my $find_row_price  = 0;
    for (my $i = 0; $i <= $oWks->{MaxRow} ; $i++) #
    {
        my $is_header = 0;
        
        my $cur_row = {};
        for (my $j = 0; $j <= 20; $j++)
        {
            my $cur_val = $oWks->{Cells}[$i][$j];
            
            if (!$cur_val)
            {
                next;
            }
            my $val = decode('cp1251', $cur_val->Value);
            if (!$headr_find && $cur_val)
            {
                #my $val = $cur_val->Value;
                #print $val;
                if ($val =~ m/(Наимен|Номенклат)/i)
                {
                    $find_row_nom = 1;
                    $header_hash{$j} = "Наименование";
                }
                if ($val =~ m/Цена/i)
                {
                    $find_row_price = 1;
                    $header_hash{$j} = "Цена";
                }
                $header_hash{$j} = "Производитель" if ($val =~ m/Фирма|Производитель/i);
                $header_hash{$j} = "Артикл/код" if ($val =~ m/Код|Артикл/i);
                #$header_hash{$j} = $val;
                #$self->stash('price_map')->{$val} = [];
                #$is_header = 1;

            }
            elsif ($headr_find && $cur_val) 
            {
                 #push $self->stash('price_map')->{$header_hash{$j}}, $cur_val->Value;
                 $cur_row->{$header_hash{$j}} = $val;
            }
        }
        #если в строке нашли столбец с упоминанием "номенклатруа" или "наименование" и цена
        #считаем что нашли шапку таблицы
        if ($find_row_nom && $find_row_price) 
        {
            $headr_find = 1;

        }
        else
        {
            $find_row_nom    = 0;
            $find_row_price  = 0;
            #%header_hash = undef;
            %header_hash = ();
        }

        if ($headr_find)
        {
            push $my_data, $cur_row;
        }

    }
    #print Dumper $self->stash->{'price_map'};
    # print Dumper $my_data;#$s->data('price_map');
    my $s = $self->app->session;
    $s->data('price_map', $my_data);
    $s->flush;
};

sub show_file {
    
    #print "show file work!";
    my $self = shift;
    my $s = $self->app->session;
    #print Dumper $s->data('price_map');
    #print Dumper $arr;
    my $arr = $s->data('price_map');
    my $tr = "<tr>";
    my $end_tr = "</tr>";
    my $td = "<td>";
    my $end_td = "</td>";
    my $dd = $tr;
    #print Dumper $self->stash('price_map');
    my $keys_hash = $arr->[1];
   # print Dumper $keys_hash;
    foreach  my $key (keys %$keys_hash) {
        $dd .= $td.$key.$end_td;
    }


    #for ( my $i = 0; $i <= $#{$self->stash('price_map')}; $i++) { # Сделать что-то с
    #    $dd .= $td.$self->stash->[$i].$end_td;
    #}
    print Dumper $arr;
    for my $href (@$arr)
    {
        $dd .= $tr;
        print $href;
        for my $item (keys $href)
        {
            my $val = $href->{$item};
            $dd .= $td.$val.$end_td;      
        }
        $dd .= $end_tr;
    }


    #while(( my $key, my $value) = each $self->stash('price_map')){
    #    $dd .=
    #};
    # for ((my $key, my $value) = each($self->stash('price_map')))
    # {
    #     my $value = $self->stash('price_map')->{$key};
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
