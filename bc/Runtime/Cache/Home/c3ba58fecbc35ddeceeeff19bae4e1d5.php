<?php if (!defined('THINK_PATH')) exit();?><html><head></head>
<body>
<a href="/index.php/Home/Company/">首页</a>
<?php if(is_array($items)): foreach($items as $key=>$t): ?><a href="/index.php/Home/Company/viewitem/id/<?php echo ($t["id"]); ?>"><?php echo ($t["name"]); ?></a><p></p><?php echo ($t["function"]); ?><p></p><p><a href="/index.php/Home/Company/deleteitem/id/<?php echo ($t["id"]); ?>">删除</a></p><?php endforeach; endif; ?>
<form action="searchitem" method="post">
<input name="key" placeholder="二维码or name"/>
<button type="submit">查询</button>
</form>
<?php echo ($page); ?>
</body>
 </html>