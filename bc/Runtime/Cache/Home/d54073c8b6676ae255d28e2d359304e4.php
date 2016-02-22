<?php if (!defined('THINK_PATH')) exit();?><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!DOCTYPE HTML>
 
<meta charset="gb2312">
<title>码农私厨</title>

<script src="/Public/js/jquery-1.6.4.min.js"></script>    


<body>

    <div class="c-home">
        <a href="/index.php/Home/bestforbaby/index">回首页</a>
        <br/>
        <a href="/index.php/Home/bestforbaby/viewitem/id/<?php echo ($item_id); ?>">查看物品</a>
        <br/>
        <a href="/index.php/Home/bestforbaby/edititem/id/<?php echo ($item_id); ?>">编辑物品</a>
    </div>
    
    <?php if(is_array($items)): foreach($items as $key=>$t): ?><div>
        <a href="/index.php/Home/bestforbaby/viewInstruction/id/<?php echo ($t["id"]); ?>"><?php echo ($t["title"]); ?></a>
        <a href="/index.php/Home/Instruction/deleteitem/id/<?php echo ($t["id"]); ?>">删除</a>
        </div><?php endforeach; endif; ?>

    <form method="post" action="/index.php/Home/Instruction/<?php echo ($action); ?>" name="f1" enctype="multipart/form-data">
        <input name="item_id" value="<?php echo ($item_id); ?>" style="display:none;"/>
        <select name="title_id">
	        <option>选择题目</option>
            <?php if(is_array($title)): foreach($title as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>" onClick="getByTitle(<?php echo ($t["id"]); ?>,<?php echo ($item_id); ?>);"><?php echo ($t["title"]); ?></option><?php endforeach; endif; ?>
        </select>
        <a href="/index.php/Home/Instruction/inserttitle">增加标题</a> 
        <script id="container" name="content" type="text/plain"></script>
        <button type="submit">提交</button>
    
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
   <script type="text/javascript">
		var getByTitle = function(title_id,item_id)
		{
			//var info = new array();
			//var param = $.param(info);
			$.ajax({ 
				type: "post", //以post方式与后台沟通
				url: "/index.php/Home/instruction/getByTitle/title_id/"+title_id+"/item_id/"+item_id, //与此php页面沟通
				dataType:'json',//从php返回的值以 JSON方式 解释
			//	data: param, //发给php的数据有两项，分别是上面传来的u和p
				success: function(json){
					
					},
				fail:function(){}
				}); 
		}
</script>

</body>
 </html>