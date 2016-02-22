<?php if (!defined('THINK_PATH')) exit();?><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!DOCTYPE HTML>
<html manifest="msj_m.manifest">
<meta charset="gb2312">
<title>码农私厨</title>

<body>
<a href="/index.php/Home/">首页</a>
<p>品牌：Company:<?php echo ($brand["companyname"]); ?>/Brand:<?php echo ($brand["name"]); ?>/Category:<?php echo ($brand["categoryname"]); ?></p>
<a href="/index.php/Home/Bestforbaby/editBrand/item_id/$item.id">重新选择</a>
<div id="layout-container"  style="width:100%;height:auto;">
 
  <div id="content" style="display:inline-block;width:70%;height:auto;overflow:hidden;">
    <form method="post" action="/index.php/Home/Bestforbaby/<?php echo ($action); ?>" name="f1" enctype="multipart/form-data">
      <input name="id" id="id" value="<?php echo ($item["id"]); ?>" style="display:none;"/>
      <br/>
      <label for="name" value="名称">名称</label>
      <input name="name" value="<?php echo ($item["name"]); ?>"/>
      <input name="brand_id" value="<?php echo ($brand["id"]); ?>"/>
      <br/>
      <label for="version" value="版本型号">版本型号</label>
      <input id="version" name="version" placeholder="版本/型号名称" value="<?php echo ($item["version"]); ?>"/>
      <br/>
      <label for="start_age" value="">最小使用月龄</label>
      <input name="start_age" placeholder="最小使用月龄"  value="<?php echo ($item["start_age"]); ?>"/>
      <br/>

      <label for="end_age" value="">最大使用月龄</label>
      <input name="end_age" placeholder="最大使用月龄"  value="<?php echo ($item["end_age"]); ?>"/>
      <br/>
      <label for="life" value="">使用寿命</label>
      <input name="life" placeholder="保质期/使用寿命"  value="<?php echo ($item["life"]); ?>"/>
      <br/>
      <label for="barcode" value="">条形码</label>
      <input name="barcode" placeholder="条形码"  value="<?php echo ($item["barcode"]); ?>"/>
      <br/>
      <label for="img" value="">插入图像</label>
      <!--<input name="instruction" placeholder="用法"  value="<?php echo ($item["instruction"]); ?>"/>-->
      <input name="img" type="text" id="img" value="<?php echo ($item["img"]); ?>" size="50" />
      <input name="thumb_img" type="text" id="thumb_img" value="<?php echo ($item["thumb_img"]); ?>" size="50" class="c-hidden" style="display:none"/>
      <input type="button" name="button2" id="button2" value="上传图片" onclick="window.open('/index.php/Home/bestforbaby/innerupload/formname/f1/editname/img','文件上传','left=300px,height=400,width=500');" class="btn" />
      <a href="javascript:ajaxUpload();">上传</a> 
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
      <script id="container" name="instruction" type="text/plain">
        <?php echo ($item["instruction"]); ?>
    </script>
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
   
    
</div>
<!--container-->
<div>
</body>
</html>