<?php
	session_start();
	//header("Access-Control-Allow-Origin: 'https://localhost'");
	header("Access-Control-Allow-Origin: 'https://192.168.43.4'");
	header("Access-Control-Allow-Credentials:true");
	//index file for tenant

	$temp_path=getcwd();
	include_once $_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/config.php";
	include_once $_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/App/tenant_ini.php";
	chdir($temp_path);
	$ini=json_decode($tenant_ini,true)[0];
	
	//Rest of customize code for Tenant....Rest of tenant customization
	
	callEvent($tenant,"tenantLoad","");
	
	if (@$_GET["UID"])
	{	
	//یک کاربر در کدام گروه ها هست
	//$userToken=select("MooniMsg","conversations",array("members"=>1),array("members.uid"=>"12346"));
	
	$allTopics=select("MooniMsg","conversations",array("name"=>1,"members"=>1,"topicId"=>1,"type"=>1,"userSeen"=>1),array("members.uid"=>$_GET["UID"]));
	
	
	//finding user name,نام کاربر
	$topics=json_decode($allTopics,true);
	for($i=0;$i<count($topics);$i++)
	if (count($topics[$i]["members"]<3)) break;
	for($j=0;$j<count($topics[$i]["members"]);$j++)
	 if ($topics[$i]["members"][$j]["uid"]==$_GET["UID"])
	 {
		 $username=$topics[$i]["members"][$j]["name"];break;}
	}
	//Loading messages
	/*
	for($i=0;$i<count($groups);$i++)
		$messages[$groups[$i]["groupId"]]=json_decode(select("MooniMsg","messages",array("content"=>1,"usersSeen"=>1),array("gid"=>$groups[$i]["groupId"]),100),true);
	*/
		
	if (!isset($_GET['UID']))  
		$sm=renderPage($tenant,$ini,"messenger");
	else
		$sm=renderPage($tenant,$ini,"messenger",array("uname"=>$username,"ugroups"=>$topics,"uid"=>$_GET["UID"]));