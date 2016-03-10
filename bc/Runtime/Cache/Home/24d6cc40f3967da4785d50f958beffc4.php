<?php if (!defined('THINK_PATH')) exit();?><select name="<?php echo ($set_name); ?>" id="<?php echo ($set_name); ?>">
<option value="">选择品牌</option>
<?php if(is_array($items)): foreach($items as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>" onClick="hideElement('new_brand');"><?php echo ($t["cn_name"]); ?></option><?php endforeach; endif; ?>
<option onClick="showElement('new_brand');">其他</option>
</select>