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

    function Search($dirPath, $namedPath, $key, $disk, &$result){     
        $xmlObj = simplexml_load_file($dirPath.'/items.xml');
        
        $nameMap = array();
        foreach($xmlObj->i as $i){
            $itemPath = $dirPath . '/' . $i['text'];
            if($i['type'] == 'f'){
                if(stristr($i['text'], $key)){
                    //echo '<tr><td>'.$disk.'</td><td>'.$namedPath.'</td><td>'.$i["text"].'</td></tr>';     
                    array_push($result, array($disk, urlencode($namedPath), urlencode($i['text']."")));                   
                }                                                                                   
            }
            else{
                $nameMap[$i["dir"].''] = $i['text'];                
            }                        
        }        
        if($items = scandir($dirPath)){
            foreach($items as $item){   
                $itemPath = $dirPath . '/' . $item;
                if(is_readable($itemPath) && $item != '.' && $item != '..' && is_dir($itemPath)){
                    Search($itemPath, $namedPath . '/' . $nameMap[$item], $key, $disk, $result);
                }
            }
        }               
    }          
               
    $myResult = array();                                                                 
    foreach($diskArray as $disk){
        Search($xmlPath.'/'.$disk, '', $obj["key"], $disk, $myResult);        
    }                             
    $jsonStr = urldecode(json_encode($myResult));     
    echo $jsonStr;
?>