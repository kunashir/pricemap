var lastsel;
(function($) 
	{
  		$(document).ready(
  			function() 
  			{
				 jQuery("#list4").jqGrid(
				 	{ 
				 		url:'get_data', 
				 		datatype: "json",
				 		height: 550, 
				 		width: 800,
				 		//colNames:['Артикл','Наименование', 'Производитель', 'Цена','Контрагент'], 
				 		colNames:['Н./п.','Артикл','Наименование', 'Производитель', 'Цена', 'Контрагент', 'Кол-во для заказа'], 
				 		colModel:[ 
				 			{name:'id',			index:'id', 		width:10, sorttype:"int"}, 
				 			{name:'art',		index:'art', 		width:10, sorttype:"int"}, 
				 			{name:'name',		index:'name',	 	width:50, sorttype:"date"}, 
				 			{name:'manufact',	index:'manufact', 	width:50 }, 
				 			{name:'price',		index:'price', 		width:20, align:"right",sorttype:"float"},
				 			{name:'contra',		index:'contra', 	width:50, align:"right",sorttype:"float"},
				 			{name:'count',		index:'count', 		width:10, align:"left", sorttype:"float", editable:true}
				 			//,
				 			//{name:'contra',		index:'contra', 		width:80, align:"right",sorttype:"float"}
				 			],
				 		rowNum:1000, 
				 		rowList:[1000,2000,3000], 
				 		pager: '#pager2', 
				 		sortname: 'art', 
				 		viewrecords: true, 
				 		sortorder: "desc", 
				 		jsonReader: {
				 			repeatitems: false, 
				 			root : "rows",
				 			page : "page",
				 			total: "total",
				 			records : "records",
				 			id 		: "0"
				 		},	
				 		onSelectRow: function(id)
				 		{ 
				 			if(id && id!==lastsel)
				 			{ jQuery('#list4').jqGrid('restoreRow',lastsel); 
				 				jQuery('#list4').jqGrid('editRow',id,true); 
				 				lastsel=id; 
				 	 		} 
				 	 	}, 
				 	 	editurl: "save_changes",			 		
				 		caption:"Данные прайсов"
				 	}
				 		
				); 
 				jQuery("#list4").jqGrid('navGrid','#pager2',{edit:false,add:false,del:false}); 
 			}
 		); })(jQuery);

var timeoutHnd;
var flAuto = false;


function gridReload()
{
	var nm_mask = jQuery("#item").val();
	var cd_mask	= jQuery("#search_cd").val();
	jQuery("#list4").jqGrid('setGridParam', {url:"get_data?nm_mask="+nm_mask+"&cd_mask="+cd_mask,page:1}).trigger("reloadGrid");
}


(function($) 
	{
  		$(document).ready(
  			function() 
  			{
				jQuery("#order").change(
					function(){
						var cur_state = 0;
						if ($("#order").is(":checked"))
						{
							cur_state = 1;
						}
						jQuery("#list4").jqGrid('setGridParam', {url:"get_data?show_order="+cur_state,page:1}).trigger("reloadGrid");
						
					}
			)
}); })(jQuery);


function enableAutosubmit(state)
{
	flAuto = state;
	jQuery("#submitButton").attr("disabled", state);
}

function doSearch(ev)
{
	if(!flAuto)
		return;
	if(timeoutHnd)
		clearTimeout(timeoutHnd);
	timeoutHnd = setTimeout(gridReload, 500);
}

var uploader;

(function($) 
	{
  		$(document).ready(
  			function() 
			{   
				uploader = new qq.FileUploader({
	            element: $("#upload")[0],
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
	$("#server_ans").html("ddd");
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

(function($) 
	{
  		$(document).ready(
  			function() 
  			{
				 jQuery("#contra_table").jqGrid(
				 	{ 
				 		url:'get_index', 
				 		datatype: "json",
				 		height: 550, 
				 		width: 800,
				 		//colNames:['Артикл','Наименование', 'Производитель', 'Цена','Контрагент'], 
				 		colNames:['Н./п.','Наименование', 'E-mail', 'Путь к прайсу'], 
				 		colModel:[ 
				 			{name:'id',			index:'id', 		width:10, sorttype:"int"}, 
				 			{name:'name',		index:'name',	 	width:50, sorttype:"date"}, 
				 			{name:'email',		index:'email', 		width:50 }, 
				 			{name:'price_path',	index:'price_path',	width:10, align:"left", sorttype:"float", editable:true}
				 			//,
				 			//{name:'contra',		index:'contra', 		width:80, align:"right",sorttype:"float"}
				 			],
				 		rowNum:10, 
				 		rowList:[10,20,30], 
				 		pager: '#contra_pager', 
				 		sortname: 'name', 
				 		viewrecords: true, 
				 		sortorder: "desc", 
				 		jsonReader: {
				 			repeatitems: false, 
				 			root : "rows",
				 			page : "page",
				 			total: "total",
				 			records : "records",
				 			id 		: "0"
				 		},	
				 		onSelectRow: function(id)
				 		{ 
				 			if(id && id!==lastsel)
				 			{ jQuery('#list4').jqGrid('restoreRow',lastsel); 
				 				jQuery('#list4').jqGrid('editRow',id,true); 
				 				lastsel=id; 
				 	 		} 
				 	 	}, 
				 	 	editurl: "",			 		
				 		caption:"Справочник поставщиков"
				 	}
				 		
				); 
 				jQuery("#contra_table").jqGrid('navGrid','#contra_pager',{edit:false,add:false,del:false}); 
 			}
 		); })(jQuery);