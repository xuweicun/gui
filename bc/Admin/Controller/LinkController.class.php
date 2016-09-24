<?php
namespace Admin\Controller;
use Think\Controller\RestController;

class LinkController extends RestController 
{
	var $db;

	function __construct()
	{
		$this->db = M(I('get.item_table'));
	}

    public function index(){
        echo json_encode(C());
        //$this->response('', 'html', 404);
    }

    public function size()
    {
        $size = $this->db->count();
        $this->response("$size", 'html');
    }

    public function maxid()
    {
        $id = $this->db->field('id')->order('id desc')->find();
        if ($id) {
            $id = $id['id'];
            $this->response("$id", 'html');
        }
        else {
            $this->response('', 'html', 204);
        }
    }

    public function where()
    {
        $items = $this->db->where(I('get.where'))->order('id desc')->select();
        
        if ($items) {
            $this->response($items, 'json');
        }
        else {
            $this->response('[]', 'html', 200);
        }
    }

    public function item()
    {
    	switch ($_SERVER['REQUEST_METHOD']) {
    		case 'PUT':
    			$this->update();
    			break;

    		case 'DELETE':
    			$this->delete();
    			break;
    		
    		case 'GET':
    			$this->read();
    			break;

    		default:
    			$this->response('', 'html', 400);
    			break;
    	}
    }

    public function items()
    {
    	switch ($_SERVER['REQUEST_METHOD']) {
    		case 'POST':
    			$this->create();
    			break;
    		
    		case 'GET':
    			$this->read_all();
    			break;

    		default:
    			$this->response('', 'html', 400);
    			break;
    	}
    }

    public function create()
    {
    	$data = json_decode(file_get_contents('php://input'), true);
    	if (!$data) {
			$this->response('Invalid input data, need json object', 'html', 400);
    		return;
    	}

    	$ret = $this->db->add($data);
    	if ($ret) {
    		$this->response(array('id'=>$ret), 'json', 201);
    	}
    	else {
    		$this->response($this->db->getError(), 'html', 417);
    	}
    }

 	public function read_all()
    {
        $size = 20;
        $items = $this->db->order('id desc')->limit($size);

        $id = I('get.id');
        if ($id) {
            $items = $items->where("id<=$id");      
        }

        $items = $items->select();

    	if ($items) {
    		$this->response($items, 'json');
    	}
    	else {
    		$this->response('[]', 'json', 200);
    	}
    }
 
    public function read()
    {
    	$id = I('get.id');
    	$items = $this->db->where("id=$id")->find();
    	if ($items) {
    		$this->response($items, 'json');
    	}
    	else {
    		$this->response($this->db->getError(), 'html', 404);
    	}
    }
    public function update()
    {
    	$data = json_decode(file_get_contents('php://input'), true);
    	if (!$data) {
			$this->response('Invalid input data, need json object', 'html', 400);
    		return;
    	}

    	$item = $data; 
    	$item['id'] = I('get.id');

    	$ret = $this->db->field('id')->where($item)->find();
    	if ($ret) {
    		$this->response('', 'html', 304);
    		return;
    	}

    	$ret = $this->db->save($item);
    	if ($ret) {
    		$this->response($ret, 'json');
    	}
    	else {
    		$this->response($this->db->getError(), 'html', 417);
    	}
    }

    public function delete()
    {
    	$id = I('get.id');
    	$ret = $this->db->where("id=$id")->delete();
    	if ($ret) {
    		$this->response($ret, 'json');
    	}
    	else {
    		$this->response($this->db->getError(), 'html', 403);
    	}
    }
}
