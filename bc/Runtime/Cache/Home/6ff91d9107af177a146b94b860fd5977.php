<?php if (!defined('THINK_PATH')) exit();?><html>
<head>
</head>
<script type="text/javascript" src="/Public/js/jquery-1.6.4.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/Public/js/onload.js" charset="utf-8"></script>

<body>
<a href="/index.php/Home/bestforbaby/insertitem">增加项目</a> <a href="/index.php/Home/bestforbaby/viewitems">查看所有项目</a>
<form action="/index.php/Home/bestforbaby/searchitem" method="post">
  <input name="key" placeholder="二维码/名称/品牌/厂商"/>
  <button type="submit">查询</button>
  <br/>
</form>
<!--根据类别搜索-->
<div name="search-by-ctgr">
  <label for"top_layer">根据类别选择</label>
  <select name="top_layer" id="top_layer">
    <option value="">一级类目</option>
    <?php if(is_array($layer_top)): foreach($layer_top as $key=>$t): ?><option value="<?php echo ($t["id"]); ?>" onClick="javascript:ajaxListChildren(this,'/index.php/Home/Category/listChildren/father_id/<?php echo ($t["id"]); ?>');"><?php echo ($t["name"]); ?></option><?php endforeach; endif; ?>
    <option value="0" onClick="ajaxListChildren(this,'/index.php/Home/Category/listChildren/layer/1');">其他</option>
  </select>
  <select name="mid_layer" id="mid_layer">
  <option value="">二级类目</option>
  </select>
  <div id="btm_layer">名称</div>
</div>
</body>
</html>