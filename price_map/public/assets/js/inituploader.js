var uploader;

(function($) 
	{
  		$(document).ready(
  			function() 
			{   
				uploader = new qq.FileUploader({
	            element:$("#upload")[0],
	            action: 'upload',
	            params: {
	                contra: $("#contra_sel").val(),
                  nom_col: '',
                  price_col: '',
                  first_row: '',
                  manuf_col: '',
                  art_col: '', 
                  balance_col: '',
                  course: 1
	            },
	            multiple: false,
	            uploadButtonText: 'Загрузить файл',
	            cancelButtonText: 'Отменить',
	            failUploadText: 'Ошибка загрузки!',
	            dragText: 'Перетащите сюда файл'
        		});
        	});
})(jQuery);


function setNewParams ()
{
	uploader.setParams( {contra: $("#contra_sel").val(), nom_col: $("#nom_col").val(), price_col: $("#price_col").val(), 
                    first_row: $("#first_row").val(), manuf_col: $("#manuf_col").val(), art_col: $("#art_col").val(), balance_col:$("#balance_col").val(), 
                    course:$("#course").val() });
}

function del_all()
{
	//$("#server_ans").html("ddd");
      $.ajax(
      {
        type: "POST",
        url:  "del_all",
        data: "",
        dataType: "text",
        error:  function(XMLHttpRequest, textStatus, errorThrown)
        {
          alert("Ошибка удаления!");
        },
        success:  function(result)
        {
          //alert (result);
          $("#server_ans").html(result);
        }
          
      });
} 


function get_price_param()
{
  //$("#server_ans").html("ddd");
      $.ajax(
      {
        type: "GET",
        url:  "price_param",
        data: "contra="+$("#contra_sel").val(),
        dataType: "json",
        error:  function(XMLHttpRequest, textStatus, errorThrown)
        {
          alert("Ошибка удаления!");
        },
        success:  function(result)
        {
          //alert (result);
          //$("#server_ans").html(result);
         // price_param =  JSON.parse(result);
          $("#nom_col").val(result.nom_col);
          $("#price_col").val(result.price_col);
          $("#first_row").val(result.first_row);
          $("#manuf_col").val(result.manuf_col);
          $("#art_col").val(result.art_col);
          $("#balance_col").val(result.balance_col);
        }
          
      });
} 

(function($) 
{
  $(document).ready(
    function() 
    {
        $("#contra_sel").change(
         function() 
         {
            setNewParams();
            get_price_param (); 
                  
          });
      
    });
  })(jQuery);