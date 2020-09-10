<?php
	
	$tempPath=getcwd();
	chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
	include_once("config.php");
	
	if ($_POST['Tid'])
	{	
		$tenant=findTenant($_SERVER['REQUEST_URI']);
		$tempPath=getcwd();
		
		chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/App/Db/");
		require_once("functions.php");
		chdir($tempPath);
			
		//callEvent($tenant,"formSubmit");
		callEvent($tenant,"chatLoad","");
		
		$messages=select($tenant,"messages",array("content"=>1,"userId"=>1,"presentationId"=>1,"createDate"=>1),array("parentId"=>$_POST["Tid"]),0,array("createDate"));
		
		//find unique user list
		$allMessages=json_decode($messages,true);
		
		$users=array();
		for($i=1;$i<count($allMessages);$i++)
			if (!in_array($allMessages[$i]["userId"],$users))
				array_push($users,$allMessages[$i]["userId"]);
		
		for($j=0;$j<count($users);$j++)	
		{
			$userInfo=select($tenant,"users",array("name"=>1),array("userId"=>$users[$j]));
			$userInfo=json_decode($userInfo,true);
			$users[$j]=array("uname"=>$users[$j],"realName"=>$userInfo[0]['name']);
		}
		
		for($i=0;$i<count($allMessages);$i++)
			$allMessages[$i]["userId"]=$users[array_search($allMessages[$i]["userId"],array_column($users,"uname"))];
		
		die(json_encode($allMessages));		
	}
	else
		return false;
?>