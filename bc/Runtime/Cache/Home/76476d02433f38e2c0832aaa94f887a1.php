<?php if (!defined('THINK_PATH')) exit();?><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!DOCTYPE HTML>
<html manifest="msj_m.manifest">        
<meta charset="gb2312">
<title>码农私厨</title>

<script src="/js/jquery-1.6.4.min.js"></script>    
<script type="text/javascript" charset="utf-8">

var ajaxUpload = function()
{
	//var info = new array();
	//var param = $.param(info);
	$.ajax({ 
		type: "post", //以post方式与后台沟通
		url: "/index.php/Home/bestforbaby/upload", //与此php页面沟通
		dataType:'json',//从php返回的值以 JSON方式 解释
	//	data: param, //发给php的数据有两项，分别是上面传来的u和p
		success: function(json){alert(json['result']);},
		fail:function(){}
		}); 
}
</script>

<body>
<a href="/index.php/Home/Company/">首页</a>
<form method="post" action="/index.php/Home/Company/insertitem" name="f1" enctype="multipart/form-data">
<input name="name" placeholder="名称" value="<?php echo ((isset($item["name"]) && ($item["name"] !== ""))?($item["name"]):''); ?>"/>
<input name="alias" placeholder="别名" value="<?php echo ($item["alias"]); ?>"/>
<input name="country" placeholder="国家" value="<?php echo ((isset($item["country"]) && ($item["country"] !== ""))?($item["country"]):''); ?>"/>
<input name="since" placeholder="创建年份" value="<?php echo ((isset($item["since"]) && ($item["since"] !== ""))?($item["since"]):'2000'); ?>"/>
 <script id="container" name="instruction" type="text/plain">

    </script>
<button type="submit">插入</button>

</form>
 <!-- 加载编辑器的容器 -->
   
    <!-- 配置文件 -->
    <script type="text/javascript" src="/Public/js/ueditor.config.js"></script>
    <!-- 编辑器源码文件 -->
    <script type="text/javascript" src="/Public/js/ueditor.all.js"></script>
    <!-- 实例化编辑器 -->
    <script type="text/javascript">
        var ue = UE.getEditor('container');
    </script>
<?php if(is_array($instructions)): foreach($instructions as $key=>$t): ?><div>
<p><?php echo ($t["title"]); ?></p>
<p><?php echo ($t["content"]); ?></p>
<a href="/index.php/Home/bestforbaby/editInstruction/id/<?php echo ($t["id"]); ?>">修改</a>
<a href="/index.php/Home/bestforbaby/deleteInstruction/id/<?php echo ($t["id"]); ?>">删除</a>
</div><?php endforeach; endif; ?>
<a href="/index.php/Home/bestforbaby/addInstruction/id/<?php echo ($item["id"]); ?>">增加说明项</a>
</body>
 </html>