<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>文件检索</title>
    <!-- Favicon and touch icons -->


    <!-- Vendor CSS-->
    <link href="/Public/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/Public/assets/vendor/skycons/css/skycons.css" rel="stylesheet" />
    <link href="/Public/assets/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <link href="/Public/assets/vendor/css/pace.preloader.css" rel="stylesheet" />

    <!-- Plugins CSS-->
    <link href="/Public/assets/plugins/bootkit/css/bootkit.css" rel="stylesheet" />
    <link href="/Public/assets/plugins/select2/select2.css" rel="stylesheet" />
    <link href="/Public/assets/plugins/jquery-datatables-bs3/css/datatables.css" rel="stylesheet" />

    <!-- Theme CSS -->
    <link href="/Public/assets/css/jquery.mmenu.css" rel="stylesheet" />

    <!-- Page CSS -->
    <link href="/Public/assets/css/style.css" rel="stylesheet" />
    <link href="/Public/assets/css/add-ons.min.css" rel="stylesheet" />

    <!-- end: CSS file-->


    <!-- Head Libs -->
    <script src="/Public/assets/plugins/modernizr/js/modernizr.js"></script>

    <style>
      a{
      color: #777 !important;
      }
    </style>
  </head>
  <body>
    <div>
      <div class="panel panel-primary bk-margin-15">
        <div class="panel-heading ">
          <h6>
            <i class="fa fa-table red"></i><span class="break"></span>文件检索
          </h6>
        </div>
        <div class="panel-body bk-padding-15">
          <div class="search bk-padding-5 row">
            <form action="search.php" method="post">
              <div class="input-group input-search">
                <input type="text" class="form-control" name="key" id="keyword" placeholder="请输入关键词..." value="<?php echo $_POST['key']; ?>" />
                <span class="input-group-btn">
                  <button class="btn btn-default" type="submit" id="btnSearch">
                    <i class="fa fa-search"></i>
                  </button>
                </span>
              </div>
            </form>
          </div>
          <br />
          <div class="row bk-padding-15">
            <table class="table table-bordered table-striped">
              <thead>
                <tr>
                  <th>序号</th>
                  <th>硬盘</th>
                  <th>路径</th>
                  <th>文件名</th>
                </tr>
              </thead>
              <tbody>
                <?php
                  /**
                   * Created by PhpStorm.
                   * User: link
                   * Date: 2016/3/8
                   * Time: 19:33
                   */
                      header("Access-Control-Allow-Origin:*");

                      $obj = $_POST;                       
                      if(empty($obj["key"])){   
                          echo '[]';
                          return;   
                      }           
      
                      $xmlPath = 'xml';
                      $diskArray = array();
                      if($items = scandir($xmlPath)){
                          foreach($items as $item){
                              $itemPath = $xmlPath . '/' . $item;
                              if(is_readable($itemPath) && $item != '.' && $item != '..' && is_dir($itemPath)){
                                  array_push($diskArray, $item);
                              }  
                          }  
                      }    
                      
                      $index = 1;

                      function Search($dirPath, $namedPath, $key, $disk, &$idx){     
                          $xmlObj = json_decode(file_get_contents($dirPath.'/items.json'));
        
                          foreach($xmlObj->data as $i){            
                              if (stristr($i->text, $key)){ 
                                  echo '<tr><td>'.$idx.'</td><td>'.$disk.'</td><td>'.$namedPath.'</td><td>'.$i->text.'</td><tr>';
                                  $idx++;
                                  flush();
                              }
            
                              if ($i->type == 'd'){
                                  $itemPath = $dirPath . '/' . $i->dir;
                                  if (is_readable($itemPath) && is_dir($itemPath)){
                                      Search($itemPath, $namedPath . '/' . $i->text, $key, $disk, $idx);
                                  }
                              }
                          }     
                      }  
                      
                      foreach($diskArray as $disk){
                          Search($xmlPath . '/' . $disk, '', $obj["key"], $disk, $index);        
                      }     
                      
                      if ($idx == 1){
                          echo '<tr><td colspan="4">没有找到任何文件或文件夹</td><td><tr>';
                      }
                  ?>                
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>


