<?php
namespace Admin\Controller;
//require_once '\PHPWord-master\src\PhpWord\Autoloader.php';
header("Content-Type:text/html;charset=gb2312");
use Think\Controller;

header('Access-Control-Allow-Origin:*');
header('Access-Control-Allow-Headers: X-Requested-With,content-type');
$content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
if ($content_type_args[0] == 'application/json') {
    $_POST = json_decode(file_get_contents('php://input'), true);
}

class CheckController extends Controller
{
    /*********
     * @index
     * @todo: 停止自检
     * @author: wilson xu
     */
    public function stopCheck()
    {
        //check permission --to delay

        //initiate database   --generate model
        $id = I("get.id");
        $db = M("CheckPlan");
        $rst = $db->where("id=$id")->find();
        if(!$rst){
            $this->_ajaxReturn($rst);
        }
        $rst['modify_time'] = time();
        $rst['status'] = C('PLAN_STATUS_CANCELED');
        $sts = $db->save($rst);
        $this->_ajaxReturn($sts);
    }
    public function startCheck()
    {
        //check permission --to delay

        //initiate database   --generate model
        $id = I("get.id");
        $db = M("CheckPlan");
        $rst = $db->where("id=$id")->find();
        $rst['start_time'] = time();
        $rst['modify_time'] = time();
        $sts = $db->save($rst);
        $this->_ajaxReturn($sts);
    }
    private function _ajaxReturn($rst = false){
        $result = array('status'=>'0');
        if(!$rst){
            $result['status'] = '1';
        }
        $this->AjaxReturn($result);
    }


}
