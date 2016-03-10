<?php if (!defined('THINK_PATH')) exit();?><html>

<head>
</head>
<body>

<a href="/index.php/Home/Category/">首页</a>
<!--展示已有内容-->
<a href="javascript:toggleElement('container')">查看所有同级物品</a> 
<div id="container" style="display:none;background-color:#d6b;color:white;">
<?php if(is_array($items)): foreach($items as $key=>$t): echo ($t["name"]); ?> <a href="/index.php/Home/Category/viewitem/id/<?php echo ($t["id"]); ?>">查看</a> <a href="/index.php/Home/Category/edititem/id/<?php echo ($t["id"]); ?>">编辑</a>
          <br/><?php endforeach; endif; ?>    
</div>
 

<form action="/index.php/Home/Category/insertitem" method="post">
    <input name="name" placeholder="类目名称"/>
    <br/>
    <?php if(($layer) < "2"): ?><select name="father_id">
        <option value="0">选择上级</option>
        <?php if(is_array($father)): foreach($father as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>"><?php echo ($t["name"]); ?></option><?php endforeach; endif; ?>
    </select>
	<a href="/index.php/Home/Category/insertitem/layer/<?php echo ($layer+1); ?>">增加新的上级目录</a> 
    <br/><?php endif; ?>  
    <input name="layer" value="<?php echo ($layer); ?>" style="display:none"/>
    <input type="submit" value="增加"/>
</form>
<?php if(($layer) == "0"): else: ?>
<a href="/index.php/Home/Category/insertitem/layer/0">插入品名</a>
<br/><?php endif; ?>
<?php if(($layer) != "1"): ?><a href="/index.php/Home/Category/insertitem/layer/1">插入类目</a><?php endif; ?>
<br/>

<script src="/Public/js/jquery-1.6.4.min.js" charset="utf-8"></script> 
<script type="text/javascript" src="/Public/js/onload.js"></script> 
<script  type="text/javascript">

</script> 


</body>
 </html>