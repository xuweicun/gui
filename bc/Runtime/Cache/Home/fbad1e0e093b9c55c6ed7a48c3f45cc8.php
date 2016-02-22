<?php if (!defined('THINK_PATH')) exit();?><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!DOCTYPE HTML>
<html manifest="msj_m.manifest">
<meta charset="gb2312">
<title>码农私厨</title>

<body>
<a href="/index.php/Home/">首页</a>
<h1>选择要插入物品的厂商</h1>

        <?php if(is_array($items)): foreach($items as $key=>$t): echo ($t["name"]); ?> <a href="/index.php/Home/Bestforbaby/insertitem/brand_id/<?php echo ($t["id"]); ?>">插入物品</a> <a href="/index.php/Home/brand/viewitems/id/<?php echo ($t["id"]); ?>">查看品牌产品</a>
          <br/><?php endforeach; endif; ?>       

<!--container-->
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