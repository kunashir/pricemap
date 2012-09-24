use strict;
use warnings;
package PriceMap::Analyzer;
use Mojo::Base 'Mojolicious::Controller';
use PriceMap::DB::Contra; 
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



#формирование сводного заказка
sub cons_order {
    my $self = shift;
    my $s = $self->app->session;
    my $arr = $s->data('price_map');
    my $total_records = scalar @$arr;
    my $rows = "";
    for ( my $i = 0; $i <= $total_records ; $i++ )
    {
        my $href = $arr->[$i];
        if ($href->{count})
        {
            my $cur_row = "<tr><td>".$href->{art}."</td>"."<td>".$href->{name}."</td>"."<td>".$href->{manufact}."</td>"."<td>".$href->{price}.
                    "</td>"."<td>".$href->{contra}."</td>"."<td>".$href->{count}."</td></tr>";
            $rows .= $cur_row;
        }
    }

    $self->stash(table_data => $rows);
}

sub get_data {
    my $self = shift;
    print '=========================GET_DATA work===============================';
    my $POST = $self->req->body_params->to_hash();
    my $GET = $self->req->query_params->to_hash();
    my $params;
   # print Dumper $GET;
    if (scalar keys $GET > 0) {
        $params = $GET;
    } elsif (scalar keys $POST > 0) {
        $params = $POST;
    } else {
        $params = {};
    }
    my $nm_mask = "";
    if ($params->{'nm_mask'})
    {
        $nm_mask = $params->{'nm_mask'};
        $nm_mask =~ s/ /.*/g;
    }
    my $cd_mask = "";
    if ($params->{'cd_mask'})
    {
        $cd_mask = $params->{'cd_mask'};
    }
    my $show_order = 0;
    if ($params->{'show_order'})
    {
        $show_order = $params->{'show_order'};
    }
    my $page = $params->{'page'} || 1; # get the requested page 
    my $limit = $params->{'rows'}|| 20; # get how many rows we want to have into the grid 
    my $sidx = $params->{'sidx'}; # get index row - i.e. user click to sort 
    my $sord = $params->{'sord'}; # get the direction

    my $s = $self->app->session;
    my $arr = $s->data('price_map');

    
    my $rows = [];
    my $i = 0;
    #for my $href (@$arr)'
    my $total_records = scalar @$arr;
    print "total rec=",$total_records;
    print "nm_mask=", $nm_mask;
    #print "show_order =", $show_order;
    if ( $nm_mask ne "")
    {
        for ( my $i = 0; $i <= $total_records ; $i++ )
        {
            my $href = $arr->[$i];
            
           
                if ( $href->{name} =~ m/$nm_mask/i)
                {
                    #если значение удолетворяет маске, то добавим в выборку
                    push $rows,  $href;#\@cur_arr};
                }
              
        }
        
    }
    else #если нет фильтра, тогда все что есть возвращаем
    {
        if ($show_order != 0)          
        {
            for ( my $i = 0; $i <= $total_records ; $i++ )
            {
                my $href = $arr->[$i];    
                print "IN show order=================";
                if ($href->{count})
                {
                    push $rows, $href;
                }
            }
        }
        else
        {
            $rows = $arr;
        }
    }
   # print "ROWS====================>";
   # print Dumper $rows;
    my $total_pages = 10;
    my $records = scalar @$rows;
    print "limit->", $limit;
    if( $limit ) 
    { 
        $total_pages = int((scalar @$rows)/($limit)) || 1; 
    } 
    my $start_index = ($page -1 )*$limit;
    my $end_index = $page*$limit;
    if ($records <= $end_index)
    {
        $end_index = $records - 1;
    }
    my $result = {page => $page, total => $total_pages, records => $records };#, rows => @$rows[$start_index..$end_index]};


    my @section = @$rows[${start_index}..${end_index}];

    #print Dumper "sec=", @section;
    $result->{rows} = [@section];
    print "start index =",$start_index;
    print "end index =",$end_index;
   # print "RESULT====================>";
   # print  Dumper $result;

    $self->render(
       json => $result
    );


};

sub parser_excel {

    my $self    = shift;

    print "paser work!";
    my $filename = shift; # имя файла, который будем парсить
    my $id_contra = shift; #имя контрагента чей файл грузим, его тоже положим в данные
    my $contra = PriceMap::DB::Contra->new(id => $id_contra);
    $contra->load;
    print Dumper $contra->name;
    # Создаем объект-парсер
    my $oExcel  = new Spreadsheet::ParseExcel;
    # code page
    my $oFmtR   = Spreadsheet::ParseExcel::FmtUnicode->new(Unicode_Map => "CP1251");

    my $oBook   = $oExcel->Parse($filename, $oFmtR);
    # choice sheet
    my $oWks    = $oBook->{Worksheet}[0];
    my $headr_find      = 0;
    
    my $s = $self->app->session;
    my $my_data = $s->data('price_map');    
    #my $my_data = [];
    my $cur_id  = 0;
    if (!$my_data)
    {
        $my_data = [];
    }
    else
    {
        $cur_id = scalar @$my_data;
    }
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
                if ($val =~ m/(Наимен|Номенклат|Товар)/i)
                {
                    $find_row_nom = 1;
                    $header_hash{$j} = "name";
                }
                if ($val =~ m/Цена/i)
                {
                    $find_row_price = 1;
                    $header_hash{$j} = "price";
                }
                $header_hash{$j} = "manufact" if ($val =~ m/(Фирма|Производитель)/i);
                $header_hash{$j} = "art" if ($val =~ m/(Код|Артикл)/i);
                #$header_hash{$j} = $val;
                #$self->stash('price_map')->{$val} = [];
                #$is_header = 1;

            }
            elsif ($headr_find && $cur_val) 
            {
                 #push $self->stash('price_map')->{$header_hash{$j}}, $cur_val->Value;
                if (defined $header_hash{$j})
                {
                    $cur_row->{$header_hash{$j}} = $val;
                }
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
            $cur_row->{id}  = $cur_id;
            $cur_row->{contra} = $contra->name_utf;
            $cur_row->{contra_id} = $contra->id;
            $cur_row->{count} = 0;
            push $my_data, $cur_row;
            $cur_id++;
        }

    }
    #print Dumper $self->stash->{'price_map'};
    # print Dumper $my_data;#$s->data('price_map');
    my $s = $self->app->session;
    $s->data('price_map', $my_data);
    #print Dumper $my_data;
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
   # print Dumper $arr;
    for my $href (@$arr)
    {
        $dd .= $tr;
    #    print $href;
        for my $item (keys $href)
        {
            my $val = $href->{$item};
            $dd .= $td.$val.$end_td;      
        }
        $dd .= $end_tr;
    }

    $dd .= $end_tr;

    $self->stash( data_table => '');

}

sub save_changes{
    my $self = shift;
    my $POST = $self->req->body_params->to_hash();
    my $my_data = $self->app->session->data('price_map');

    $my_data->[$POST->{id}]->{count} = $POST->{count};
    print $my_data->[$POST->{id}];
    #self->app->session->data('price_map', $my_data);
    $self->app->session->data('price_map', $my_data);
    $self->app->session->flush;    
    $self->render(
       json => {success => 'Сохранили!'}
           );
}

sub del_all{
    my $self = shift;
    my $s = $self->app->session;
    $s->data('price_map', []);
    $s->flush;
     $self->render(
       json => {success => 'Все данные удалены!'}
           );
}

sub upload {
    

    my $self = shift;
    
    $self->redirect_to('/login') and return 0 unless($self->is_user_authenticated);
    print "upload WORK!!!!!!!!!!!!!!!!!\n";
    # Uploaded image(Mojo::Upload object)
    #print Dumper $self->req->body_params->to_hash;
    #print Dumper $self->req->content;

    my $image = $self->req->body;
    print Dumper  $self->req->body;# $self->req;#->{buffer};#->{asset}; #->{content};
    my $contra = $self->req->query_params->to_hash->{contra};
    # Not upload
    unless ($image) {
        return $self->render(
            json => {error =>"error message to display"}
        );
    }

    # Image file
    my $full_path = "uploads/".$self->req->query_params->to_hash->{qqfile};
	print $full_path;
	#print $image->filename;
    open (CURFILE, ">$full_path") or die "Can't open/create file $full_path";
    #close (CURFILE);
    print CURFILE $image;
    #my $image_file = $full_path; #"$IMAGE_BASE/" . $image->filename;
    

    $self->parser_excel($full_path, $contra);

    # Redirect to top page
    #$self->redirect_to('show_file');
    $self->render(
       json => {success => 'true'}
           );
    #$self->redirect_to('upload_form');
};

sub upload_form {
	my $self = shift;
    $self->redirect_to('/login') and return 0 unless($self->is_user_authenticated);
}

sub order {
    my $self = shift;
    my $rows = "";
      

    my $s = $self->app->session;
    my $arr = $s->data('price_map');
    my $total_records = scalar @$arr;
    my $contrs_order = {};
    for ( my $i = 0; $i <= $total_records ; $i++ )
    {
        my $href = $arr->[$i];
        if ($href->{count})
        {
            $contrs_order->{$href->{contra_id}} = [] if (!defined $contrs_order->{$href->{contra_id}});
            push $contrs_order->{$href->{contra_id}}, $href;
        }
    }

    #print Dumper $contrs_order;
    foreach  my $key (keys %$contrs_order) 
    {
        my $contra_obj = PriceMap::DB::Contra->new(id => $key);
        $contra_obj->load;
        my $cur_contra = $contrs_order->{$key};
        $rows = "";
        for (my $i = 0; $i <= scalar @$cur_contra; $i++)
        {
            my $r = $cur_contra->[$i];
            my $cur_row = "<tr><td>".$r->{art}."</td>"."<td>".$r->{name}."</td>"."<td>".$r->{manufact}."</td>"."<td>".$r->{price}.
                    "</td>"."<td>".$r->{count}."</td></tr>";
            $rows .= $cur_row;
        }
        $self->stash(table_data => $rows);
        my $data = $self->render_mail('analyzer/order');
        $self->render($self->mail(
                mail => {
                To      => $contra_obj->email,
                Subject => 'Subject',
                Data    => $data,
                }
            )
        );
    }

    
    $self->render(
       text => "sussess:true"
    );
}

1;
