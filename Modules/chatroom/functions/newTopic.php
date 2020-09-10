<?php
	$tempPath=getcwd();
	chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
	include_once("config.php");
	
	if ($_POST['title'])
	{	
		$tenant=findTenant($_SERVER['REQUEST_URI']);
		$tempPath=getcwd();
		
		chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/App/Db/");
		require_once("functions.php");
		chdir($tempPath);
			
		//callEvent($tenant,"formSubmit");
		callEvent($tenant,"newTopic","");
		
		$characters = "0123456789";
		$randomString = '';
		for ($i = 0; $i < 15; $i++) {
		$randomString .= substr($characters,rand(0,strlen($characters)-1),1);
		}
		
		insert($tenant,"conversations",array("topicId"=>$randomString,"name"=>$_POST["title"],"members"=>array(array("uid"=>$_POST["owner"])),"type"=>$_POST["type"]));
		return true;
		
	}
	else
		return false;
?>