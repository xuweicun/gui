<?php
use Think\Image; 
use Think\Page;
/**************************************
* 通用函数，用于检查用户选择了插入新数据还是从已有数据中选择 
* @param mixed $table 操作模型名
* @param mixed $id    选择的id，id为0表示未选
* @param mixed $new   新输入的值，默认为字符串
*/
function insertorselect($table,$id,$new,$key="name")
{
   $db = M($table);
   if($id>0)
   {
       $rs = $db->where("id=%d",$id)->find();
       return array("id"=>$id,"value"=>$rs[$key]);
   }
   $rs = $db->where($key." like '%".$new."%'")->find();
   if($rs)
   {
       return array("id"=>$rs['id'],"value"=>$new);
   }  
   $data = array($key => $new);
   $id = $db->add($data);   
   if($id)
   {
      return array("id"=>$id,"value"=>$new); 
   }
   return false;
   
}

/*
  * BindingTable:如果一个表中不仅关联了其他表的主键，而且还关联了
  * 另外一个值，则适用于本函数；
  * id:主键值，id_key为在关联表中的key名称；
  * name:一般为名称，name_key为关联表中的名称，也是实际需要更新的值
  * table:关联表模型名 
  */
  function update_bindingtable($id,$name,$id_key,$name_key,$table)
  {
         $db = M($table);        
         $items = $db->where("$id_key=$id")->select;
         foreach($items as $t)
         {
             $t[$name_key] = $name;
             $db->save($t);
         }
         
  }
  /****
  * 将内容按列显示
  * $items:返回值
  * $page:返回的页码
  */
  function list_pages($db,&$items,&$page,$shownum,$where = null)
  {
                      
        $count = $db->where($where)->count();      
        $show  = new \Think\Page($count,$shownum); 
        $items = $db->where($where)->limit($page->firstRow.','.$page->listRows)->select();        
        $page  = $show->show(); 
        return $count;             
  }
  function deleteItem($model,$value,$key="id")
  {
        $id = $value; 
        $db = M($model); 
        if($db->where("$key = $value")->delete())
        {
                return true;
        }
        else
        {
                return false;
        }
       
  }
  function createthumb($filepath,$webpath,$wth,$ht)
{
    $image = new \Think\Image();   
    $image->open($filepath);               
    $thumb_savepath = str_replace(".","_thumb.",$filepath);
    $image->thumb($wth,$ht)->save($thumb_savepath);
    $thumb_savepath =  str_replace(".","_thumb.",$webpath);
    dump($webpath);
    dump($thumb_savepath);
    return $thumb_savepath;
}
function htmldecode($items,$key = 'content')
{
    $new_items = array();
    foreach($items as $t)
    {
     $t[$key] = htmlspecialchars_decode($t[$key],ENT_QUOTES);      
     $new_items[] = $t;
    } 
    return $new_items;              
}
function pathconvert($cur,$absp)//当前文件，目标路径
{
    $cur = str_replace('\\','/',$cur);
    $absp = str_replace('\\','/',$absp);
    $sabsp=explode('/',$absp);
    $scur=explode('/',$cur);
    $la=count($sabsp)-1;
    $lc=count($scur)-1;
    $l=max($la,$lb);

    for ($i=0;$i<=$l;$i++)
    {
        if ($sabsp[$i]!=$scur[$i])
            break;
    }
    $k=$i-1;
    $path="";
    for ($i=1;$i<=($lc-$k-1);$i++)
        $path.="../";
    for ($i=$k+1;$i<=($la-1);$i++)
        $path.=$sabsp[$i]."/";
    $path.=$sabsp[$la];
    return $path;
}    
function string_check($c){
     $c=get_magic_quotes_gpc()?stripslashes($c):$c;
     $c = mysql_escape_string($c);
     $c = htmlspecialchars($c);
     return $c;
}
function ajaxReturn($result)
{
    if(is_array($result))
    {
       die(json_encode($result)); 
    } 
    else
    {
        $rs = array('result'=>$result);
        die(json_encode($rs));     
    }
}
?>