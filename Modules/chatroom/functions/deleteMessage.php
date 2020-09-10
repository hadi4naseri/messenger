<?php
	
	$tempPath=getcwd();
	chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
	include_once("config.php");
	
	if ($_POST['Pid'])
	{	
		$tenant=findTenant($_SERVER['REQUEST_URI']);
		$tempPath=getcwd();
		
		chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/App/Db/");
		require_once("functions.php");
		chdir($tempPath);
			
		//callEvent($tenant,"formSubmit");
		callEvent($tenant,"newMessage","");
		
		insert($tenant,"messages",array("parentId"=>$_POST["parent"],"content"=>$_POST["message"],"userId"=>$_POST["ownerId"],"usersSeen"=>array(),"edited" => false, "removedDate" => "", "createDate" => time(), "addons" => array(), "forwardedFrom" => ""));	
		die("SUCESSFUL");
	}
	else
		return false;
?>