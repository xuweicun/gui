// JavaScript Document

<!--//some day to move this into a common js file

var ajaxListChildren = function(id,ajx_url)
{
	
	$.ajax({ 
		type: "post", //以post方式与后台沟通
		url: ajx_url,//"/index.php/Home/Category/listChildren/layer/1",, //与此php页面沟通
		dataType:'json',//从php返回的值以 JSON方式 解释
		//data: param, //发给php的数据有两项，分别是上面传来的u和p
		success: function(json){
				var toReplace = "#"+id;
				if(json['error'])
				{
					$(toReplace).html();
				}
				else
				{
					$(toReplace).html(json['view']);
				//	$("#"+id).after(json['view']);
				}
			},
		fail:function(){$(id).parent().next().html();}
		});

}
var getItemImgs = function(id,sizeId,viewId,container)
{
	var params = { item_id:id, size_id:sizeId,view_id:viewId};
	var param = $.param(params);
	$.ajax({ 
		type: "post", //以post方式与后台沟通
		url: "/index.php/Home/Bestforbaby/getImg", //与此php页面沟通
		dataType:'json',//从php返回的值以 JSON方式 解释
		data: param, //发给php的数据有两项，分别是上面传来的u和p
		success: function(json){			
				if(json['error'])
				{
					$("#"+container).html();
				}
				else
				{
					$("#"+container).html(json['view']);
				//	$("#"+id).after(json['view']);
				}
			},
		fail:function(){}
		});

}
var showElement = function(id)
{
	$("#"+id).show();	
}
var hideElement = function(id)
{
	$("#"+id).hide();	
}
var removeElement = function(id)
{
	$("#"+id).remove();
}
	



var toggleElement = function(id)
{
	$("#"+id).toggle();	
	}
var removeElement = function(id)
{
	$("#"+id).remove();
}

//-->
