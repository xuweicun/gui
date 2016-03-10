<?php if (!defined('THINK_PATH')) exit();?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
</head>

<body>
<a href="/index.php/Home/Bestforbaby/viewitem/id/<?php echo ($item["id"]); ?>"><?php echo ($item["category"]); ?> <?php echo ($item["brand"]); ?></a>
<br>

 <form method="post" action="/index.php/Home/Bestforbaby/<?php echo ($action); ?>" name="f1" enctype="multipart/form-data">
 	<input name="item_id" type="text" id="item_id" value="<?php echo ($item["id"]); ?>" size="50" />
      <select name="view_id">
      <option>选择外观</option>
      <?php if(is_array($itemView)): foreach($itemView as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>"><?php echo ((isset($t["view"]) && ($t["view"] !== ""))?($t["view"]):"默认"); ?></option><?php endforeach; endif; ?>
      </select>
      <select name="size_id">
      <option>选择规格</option>
      <?php if(is_array($itemSize)): foreach($itemSize as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>"><?php echo ((isset($t["size"]) && ($t["size"] !== ""))?($t["size"]):"默认"); ?></option><?php endforeach; endif; ?>
      </select>
      <input name="img" type="text" id="img" size="50" />
      <input name="thumb_img" type="text" id="thumb_img" size="50" class="c-hidden" style="display:none"/>
      <input type="button" name="button2" id="button2" value="上传图片" onclick="window.open('/index.php/Home/bestforbaby/innerupload/formname/f1/editname/img','文件上传','left=300px,height=400,width=500');" class="btn" />
      <button type="submit">提交</button>
 </form>
</body>
</html>