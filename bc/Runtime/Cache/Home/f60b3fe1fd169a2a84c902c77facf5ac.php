<?php if (!defined('THINK_PATH')) exit();?><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!DOCTYPE HTML>
<html manifest="msj_m.manifest">
<meta charset="gb2312">
<title>码农私厨</title>

<body>
<a href="/index.php/Home/">首页</a>

<div id="left-container" style="height:50%;overflow:scroll;">
  <?php if($action == 'editBrand'): ?><a href="/index.php/Home/Bestforbaby/viewitem/id/<?php echo ($item["id"]); ?>"><?php echo ($item["name"]); ?></a><?php endif; ?>
<h1>选择厂商</h1>
        <?php if(is_array($companies)): foreach($companies as $key=>$t): ?><a href="javascript:listChildren(<?php echo ($t["id"]); ?>,'brand-container');"><?php echo ($t["name"]); ?></a>
          <br/><?php endforeach; endif; ?>       

      
</div>
<h1>选择品牌</h1>
<div id="right-container">
        <form method="post" id="brand-form" action="/index.php/Home/Bestforbaby/<?php echo ($action); ?>/action/selectbrand" name="f1" enctype="multipart/form-data">
        <input name="id" value="<?php echo ($item["id"]); ?>" style="display:none;"/>

        <div id="brand-container">
          
        </div>
        <!--For insert aciton-->
       

          <button type="submit">提交</button>
       
        <?php if($action == 'editBrand'): ?><a href="/index.php/Home/Bestforbaby/viewitem/id/<?php echo ($item["id"]); ?>">取消</a><?php endif; ?>
        </form>
</div>

<!--container-->
 <script src="/Public/js/jquery-1.6.4.min.js" charset="utf-8"></script>     
 <script type="text/javascript" charset="utf-8">

var listChildren = function(id,toReplace)
{
  $.ajax({ 
    type: "post", //以post方式与后台沟通
    url: "/index.php/Home/Company/listChildren/id/"+id, //与此php页面沟通
    dataType:'json',//从php返回的值以 JSON方式 解释
    //data: param, //发给php的数据有两项，分别是上面传来的u和p
    success: function(data){
      $("#"+toReplace).html(data['view']);
      
      },
    fail:function(){$("#"+toReplace).html();}
    });

}
</script>
</body>
</html>