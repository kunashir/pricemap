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
				 		width: 700,
				 		//colNames:['Артикл','Наименование', 'Производитель', 'Цена','Контрагент'], 
				 		colNames:['Артикл','Наименование', 'Производитель', 'Цена'], 
				 		colModel:[ 
				 			{name:'art',		index:'art', 		width:60, sorttype:"int"}, 
				 			{name:'name',		index:'name',	 	width:90, sorttype:"date"}, 
				 			{name:'manufact',	index:'manufact', 		width:100}, 
				 			{name:'price',		index:'price', 	width:80, align:"right",sorttype:"float"}
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
				 		caption:"JSON Example"
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

