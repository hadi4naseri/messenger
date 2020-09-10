<?php
	
	$tempPath=getcwd();
	chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
	include_once("config.php");
	
	if ($_POST['message'])
	{	
		$tenant=findTenant($_SERVER['REQUEST_URI']);
		$tempPath=getcwd();
		
		chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/App/Db/");
		require_once("functions.php");
		chdir($tempPath);
			
		//callEvent($tenant,"formSubmit");
		callEvent($tenant,"newMessage","");
		$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
		$randomString = '';
		for ($i = 0; $i < 30; $i++) {
		$randomString .= substr($characters,rand(0,strlen($characters)-1),1);
		}
		$insertTimestamp=time();
		$ret=insert($tenant,"messages",array("parentId"=>$_POST["parent"],"content"=>$_POST["message"],"userId"=>$_POST["ownerId"],"usersSeen"=>array(),"edited" => 0, "removedDate" => "", "createDate" => $insertTimestamp, "addons" => array(), "forwardedFrom" => "","presentationId"=>$randomString,"parentName"=>$_POST["pName"]));	
		
		die(json_encode(array("messageId"=>$randomString,"timestamp"=>$insertTimestamp)));
	}
	else
		return false;
?>