<?php if (!defined('THINK_PATH')) exit();?><!--
$optionClickAction:点击效果,与当前选项的ID有关；
$blurAction:弃选效果；
$defaultClickAction:全部弃选效果;
-->

<?php if($type == 'select'): ?><!--  <select name="<?php echo ($select_name); ?>" id="<?php echo ($id); ?>">-->
    <option><?php echo ((isset($to_do) && ($to_do !== ""))?($to_do):'Select Option'); ?></option>
    <?php if(is_array($items)): foreach($items as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>"><?php echo ($t["name"]); ?></option><?php endforeach; endif; ?>
    <option value="<?php echo ((isset($default) && ($default !== ""))?($default):'0'); ?>">其他</option>
 <!-- </select>-->
  <?php else: ?>
 <!-- <div id="<?php echo ($id); ?>">-->
    <?php if(is_array($items)): foreach($items as $key=>$t): ?><a href="<?php echo ($href); echo ($t["id"]); ?>"><?php echo ($t["name"]); ?></a> <br/><?php endforeach; endif; ?>
 <!-- </div>--><?php endif; ?>