<?php if (!defined('THINK_PATH')) exit();?><html><head></head>
<body>
<a href="/index.php/Home/bestforbaby">首页</a>
品名：<?php echo ($brand["categoryname"]); ?> <a href="/index.php/Home/category/edititem/id/<?php echo ($brand["categoryId"]); ?>">编辑品名</a>
<br/>
厂商：<?php echo (stripslashes($brand["companyname"])); ?> <a href="/index.php/Home/Bestforbaby/viewitems/id/<?php echo ($brand["companyId"]); ?>/key/company_id">同厂商物品</a>
<br/>
版本：<?php echo ($item["version"]); ?>
<br/>
品牌：<?php echo ($brand["name"]); ?>   <a href="/index.php/Home/Bestforbaby/viewitems/id/<?php echo ($item["brand_id"]); ?>/key/brand_id">同品牌</a> 
<a href="/index.php/Home/Bestforbaby/editBrand/id/<?php echo ($item["id"]); ?>">修改品牌</a>
<br/>
使用年龄：<?php echo ($item["start_age"]); ?>个月--<?php echo ($item['end_age']/12); ?>个月
<br/>
使用寿命/保质期：<?php echo (htmlspecialchars_decode($item["life"])); ?>
<br/>
商品简介：<?php echo (htmlspecialchars_decode($item["instruction"])); ?>
<br/>
<img src="<?php echo ($item["thumb_img"]); ?>" alt="<?php echo ($item["name"]); ?>coco-babycare" class="c-hidden" />
<br/>
<img src="<?php echo ($item["img"]); ?>" alt="<?php echo ($item["name"]); ?>coco-babycare"/>
<br/>
<?php if(is_array($itemView)): foreach($itemView as $key=>$t): echo ($t["view"]); ?>
<br/><?php endforeach; endif; ?>
<p><a href="/index.php/Home/bestforbaby/insertView/item_id/<?php echo ($item["id"]); ?>">增加外观选项</a></p>
<br/>
<?php if(is_array($itemSize)): foreach($itemSize as $key=>$t): echo ($t["size"]); ?><br/><?php endforeach; endif; ?>
<p><a href="/index.php/Home/bestforbaby/insertSize/item_id/<?php echo ($item["id"]); ?>">增加规格选项</a></p>

<p><a href="/index.php/Home/Bestforbaby/insertImg/item_id/<?php echo ($item["id"]); ?>">增加图片</a></p>

<!--选项区-->
<?php if(is_array($itemView)): foreach($itemView as $key=>$view): if(is_array($itemSize)): foreach($itemSize as $key=>$size): ?><a href="javascript:getItemImgs(<?php echo ($item["id"]); ?>,<?php echo ($size["id"]); ?>,<?php echo ($view["id"]); ?>,'imgs');"><?php echo ($view["view"]); ?>&nbsp;<?php echo ($size["size"]); ?></a>
		<br/><?php endforeach; endif; ?>
	<br/><?php endforeach; endif; ?>
<!--图像区-->
<div id="imgs">
	<h2>图像</h2>
<?php if(is_array($imgs)): foreach($imgs as $key=>$t): ?><img src="<?php echo ($t["thumb_img"]); ?>" alt="coco-babycare" class="c-hidden" /> 
      <a href="/index.php/Home/image/deleteitem/id/<?php echo ($t["id"]); ?>">删除图像</a><?php endforeach; endif; ?>
</div>

<?php if(is_array($instructions)): foreach($instructions as $key=>$t): ?><div>
<p><?php echo ($t["title"]); ?></p>
<p><?php echo (htmlspecialchars_decode($t["content"])); ?></p>



<a href="/index.php/Home/bestforbaby/editInstruction/id/<?php echo ($t["id"]); ?>">修改</a>
<a href="/index.php/Home/bestforbaby/deleteInstruction/id/<?php echo ($t["id"]); ?>">删除</a>
</div><?php endforeach; endif; ?>
<a href="/index.php/Home/bestforbaby/addInstruction/id/<?php echo ($item["id"]); ?>">增加说明</a>
<a href="/index.php/Home/bestforbaby/edititem/id/<?php echo ($item["id"]); ?>">编辑</a>
<script src="/Public/js/jquery-1.6.4.min.js"></script>    
<script src="/Public/js/onload.js"></script>    
</body>
</html>