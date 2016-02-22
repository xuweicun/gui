<?php if (!defined('THINK_PATH')) exit();?><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!DOCTYPE HTML>
<html manifest="msj_m.manifest">        
<meta charset="gb2312">
<title>码农私厨</title>




<body>
<a href="/index.php/Home/bestforbaby">首页</a>
<form method="post" id="form" action="/index.php/Home/Brand/<?php echo ($action); ?>" name="f1" enctype="multipart/form-data">
<input id="name" name="name" placeholder="名称" value="<?php echo ((isset($item["name"]) && ($item["name"] !== ""))?($item["name"]):''); ?>"/>
<br>
<input name="cn_name" placeholder="中文名" value="<?php echo ((isset($item["cn_name"]) && ($item["cn_name"] !== ""))?($item["cn_name"]):''); ?>" class="required"/>
<select name="corp_id">
    <option>选择厂商</option>
    <?php if(is_array($companies)): foreach($companies as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>"  onClick="listChildren(<?php echo ($t["id"]); ?>,'brand_id','new_brand');hideElement('new_corp')"><?php echo (stripslashes($t["name"])); ?></option><?php endforeach; endif; ?>
    <option onClick="javascript:showElement('new_corp');hideElement('old_brand');removeElement('brand_id');" >其他</option>
</select>

<a href="/index.php/Home/company/insertitem">新增</a>
  <br/>

<div id="category-container">
    <h2>选择类别</h2>
    <?php if(is_array($category)): foreach($category as $key=>$t): ?><a href="javascript:ajaxListChildren('ctgr_id','/index.php/Home/Category/listChildren/id/<?php echo ($t["id"]); ?>');"><?php echo ($t["name"]); ?></a>
      <BR><?php endforeach; endif; ?>
    <a href="javascript:ajaxListChildren('ctgr_id','/index.php/Home/Category/listChildren/layer/1');">其他</a>
</div>
<BR>
<select name="ctgr_id" id="ctgr_id">
    <option>选择品名</option>
        <?php if(is_array($items)): foreach($items as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>"><?php echo ($t["name"]); ?></option><?php endforeach; endif; ?>    
</select>
<a href="/index.php/Home/category/insertitem">新增</a>
  <br/>

 <script id="container" name="description" type="text/plain">
        <?php echo ($item["description"]); ?>
 </script>
<button type="submit">提交</button>

</form>
 <!-- 加载编辑器的容器 -->
   <script src="/Public/js/jquery-1.6.4.min.js"></script>    
   <script src="/Public/js/onload.js"></script>    
   <script src="/Public/js/jquery-validation-1.14.0/dist/jquery.validate.js"></script>    
    <!-- 配置文件 -->
    <script type="text/javascript" src="/Public/js/ueditor.config.js"></script>
    <!-- 编辑器源码文件 -->
    <script type="text/javascript" src="/Public/js/ueditor.all.js"></script>
    <!-- 实例化编辑器 -->
    <script type="text/javascript">
        var ue = UE.getEditor('container');
        $(function() {  
        $("#form").validate({  
        rules: {  
         name: "required"  
                }  
         });  
      }); 
    </script>

</body>
 </html>