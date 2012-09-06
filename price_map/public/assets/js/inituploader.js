var uploader;

(function($) 
	{
  		$(document).ready(
  			function() 
			{   
				uploader = new qq.FileUploader({
	            element:$("#upload")[0],
	            action: '/upload',
	            params: {
	                action: 35,
	                contra: $("#contra").val()
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
	uploader.setParams( {contra: $("#contra").val()});
}

function del_all()
{
	//$("#server_ans").html("ddd");
      $.ajax(
      {
        type: "POST",
        url:  "/del_all",
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