<?php if (!defined('THINK_PATH')) exit();?><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!DOCTYPE HTML>
<html manifest="msj_m.manifest">
<meta charset="gb2312">
<title>码农私厨</title>

<body>
<a href="/index.php/Home/bestforbaby">首页</a>
<p></p>
<a href="/index.php/Home/bestforbaby/viewitem/id/$item_id">查看物品</a>

 <br/>
 <?php if(is_array($items)): foreach($items as $key=>$t): echo ((isset($t["size"]) && ($t["size"] !== ""))?($t["size"]):"默认规格"); ?><a href="/index.php/Home/bestforbaby/deletesize/id/<?php echo ($t["id"]); ?>">删除</a>
 <br/><?php endforeach; endif; ?>
<form method="post" action="/index.php/Home/Bestforbaby/insertsize" name="f1" enctype="multipart/form-data">
  <input name="item_id" value="<?php echo ($item_id); ?>" style="display:none;"/>
  <br/>
  <label for="size">输入规格描述：</label>
  <input id="size" name="size" placeholder="默认规格" value="" />
  <br/>
 
 
  <button type="submit">提交</button>
</form>
<!-- 加载编辑器的容器 --> 
 <script src="/Public/js/jquery-1.6.4.min.js" charset="utf-8"></script> 
  <script type="text/javascript" charset="utf-8">

var listChildren = function(id,toRemove,toAdd)
{
	$.ajax({ 
		type: "post", //以post方式与后台沟通
		url: "/index.php/Home/Company/listChildren/id/"+id, //与此php页面沟通
		dataType:'json',//从php返回的值以 JSON方式 解释
		//data: param, //发给php的数据有两项，分别是上面传来的u和p
		success: function(json){
			$("#"+toRemove).remove();
			if(json['view'])
			{
				$("#"+toAdd).after(json['view']);
			}
			},
		fail:function(){alert("1");}
		});

}
var cancelSelect = function(id)
{
	 $("#"+id).empty(); //设置Select的Text值为jQuery的项选中 

	}
var showElement = function(id)
{
	
	$("#"+id).show();	
}
var hideElement = function(id)
{
	$("#"+id).hide();	
}
var toggleElement = function(id)
{
	$("#"+id).toggle();	
	}
var removeElement = function(id)
{
	$("#"+id).remove();
}

</script> 
 
</body>
</html>