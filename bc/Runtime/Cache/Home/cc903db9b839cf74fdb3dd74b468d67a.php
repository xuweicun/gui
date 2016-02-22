<?php if (!defined('THINK_PATH')) exit();?>
<?php if(is_array($imgs)): foreach($imgs as $key=>$t): ?><img src="<?php echo ($t["thumb_img"]); ?>" alt="coco-babycare" class="c-hidden" /> 
      <a href="/index.php/Home/image/deleteitem/id/<?php echo ($t["id"]); ?>">删除图像</a><?php endforeach; endif; ?>