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
				 		colNames:['Артикл','Наименование', 'Производитель', 'Цена','Контрагент'], 
				 		colModel:[ 
				 			{name:'art',		index:'art', 		width:60, sorttype:"int"}, 
				 			{name:'name',		index:'name',	 	width:90, sorttype:"date"}, 
				 			{name:'manufact',	index:'manufact', 		width:100}, 
				 			{name:'price',		index:'price', 	width:80, align:"right",sorttype:"float"},
				 			{name:'contra',		index:'contra', 		width:80, align:"right",sorttype:"float"}
				 			],
				 		rowNum:10, 
				 		rowList:[10,20,30], 
				 		pager: '#pager2', 
				 		sortname: 'art', 
				 		viewrecords: true, 
				 		sortorder: "desc", 
				 		repetable: "false", 
				 		caption:"JSON Example"
				 	}
				 		
				); 
 				jQuery("#list4").jqGrid('navGrid','#pager2',{edit:false,add:false,del:false}); 
 			}
 		); })(jQuery);