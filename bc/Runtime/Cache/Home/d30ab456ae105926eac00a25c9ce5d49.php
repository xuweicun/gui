<?php if (!defined('THINK_PATH')) exit();?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>上传图片</title>
<style type="text/css">
*{padding:0px; margin:0px; font-size:14px;}
.box{margin:0 auto; width:400px; height:200px; line-height:200px; background-color:#DCF7FC; display:block; padding-left:10px;}
#button{ padding:2px 4px;}
</style>
</head>

<body>
<div class="title" style="margin:0 auto; width:400px; height:30px; line-height:30px; background-color:#CCC;padding-left:10px; ">选择图片</div>
<div class="box">
<form action="/index.php/Home/bestforbaby/uploadimg" method="post" enctype="multipart/form-data">
 <input type="hidden" name="formname" id="formname" value="<?php echo $_REQUEST['formname'];?>"/>
<input type="hidden" name="editname" id="editname" value="<?php echo $_REQUEST['editname'];?> " />
    <input type="hidden" name="f_type" id="f_type"  value="<?php echo $_REQUEST['f_type']; ?>"/>
<input type="file" name="img" id="upfile"  />

 <input type="submit" name="button" id="button" value="上传" />
  
</form>
</div>
</body>