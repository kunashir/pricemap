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
				 			repeatable: false, 
				 			root : "rows",
				 			page : "page",
				 			total: "totalpages",
				 			records : "records",
				 			id 		: "0"
				 		},				 		
				 		caption:"JSON Example"
				 	}
				 		
				); 
 				jQuery("#list4").jqGrid('navGrid','#pager2',{edit:false,add:false,del:false}); 
 			}
 		); })(jQuery);