var lastsel;
var lastsel_contra;
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
				 			{name:'id',			index:'id', 		width:10, sorttype:"int", editable:false, editoptions:{readonly:true, size:10}}, 
				 			{name:'name',		index:'name',	 	width:50,  editable:true, editoptions:{size:50}}, 
				 			{name:'email',		index:'email', 		width:50 , editable:true, editoptions:{size:50}}, 
				 			{name:'price_path',	index:'price_path',	width:10, align:"left", editable:true,  editoptions:{size:50}}
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
				 			id 		: "id"
				 		},	
				 		// onSelectRow: function(id)
				 		// { 
				 		// 	if(id && id!==lastsel_contra)
				 		// 	{ jQuery('#contra_table').jqGrid('restoreRow',lastsel_contra); 
				 		// 		jQuery('#contra_table').jqGrid('editRow',id,true); 
				 		// 		lastsel_contra=id; 
				 	 // 		} 
				 	 // 	}, 
				 	 	editurl: 'operations_contra',			 		
				 		caption:"Справочник поставщиков"
				 	}
				 		
				);
				//jQuery("#grid_id").jqGrid('navGrid',selector,options,pEdit,pAdd,pDel,pSearch );  
 				jQuery("#contra_table").jqGrid('navGrid','#contra_pager') ;//,
 					// {edit:true,add:true,del:true},
 					// {height:280, reloadAfterSubmit:false},
 					// {height:280, reloadAfterSubmit:false},
 					// {reloadAfterSubmit:false},
 					// {}); 
 				//jQuery("#grid_id").editGridRow( new);  
 				//jQuery("#contra_table").jqGrid('inlineNav',"#contra_table");
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



