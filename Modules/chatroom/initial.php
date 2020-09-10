<?php

function chatroom_initial(&$smartyObj,$handle)
{

	
	die('in local ini');

$tempPath=getcwd();

chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/App/Db/");
require_once("functions.php");
chdir($tempPath);

$tenant=findTenant($_SERVER['REQUEST_URI']);

callEvent($tenant,"chatroomLoad");

//extract item data from collection
$itemData=select($tenant,"conversations",array("languages"=>1,"data"=>1,"addons"=>1),array("handle"=>$handle));
$itemData=json_decode($itemData,true)[0];

$languages=$itemData["languages"];

//find default theme in dafault language
for($i=0;$i<count($languages);$i++)
	if ($languages[$i]["isDefault"]==true)
		for($j=0;$j<count($languages[$i]["templates"]);$j++)
			if ($languages[$i]["templates"][$j]["isDefault"]==true)
				$template=$languages[$i]["templates"][$j];


//load addons data and templates

$addons=$itemData["addons"];

for($i=0;$i<count($addons);$i++)
{
		if(file_exists(modulesPath.$addons[$i]["moduleName"]."/initial.php"))
		{	
		  $func_name=$addons[$i]["moduleName"]."_initial";
		  require_once(modulesPath.$addons[$i]["moduleName"]."/initial.php");
		  //because can not send NULL to refrenced parameter, define variable with NULL value and send it
		  $ref_null=NULL;
		  $ini_data=$func_name($ref_null,$addons[$i]["handle"]);
		  
		  $addons[$i]["addonData"]=$ini_data;
		  $smartyObj->assign($addons[$i]["moduleName"]."_".$addons[$i]["handle"]."_ini_data",$ini_data);
		}
}
chdir($tempPath);
return array("template"=>$template,"content"=>$itemData["data"],"addons"=>$addons);	

}
