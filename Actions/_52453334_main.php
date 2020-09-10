<?php

chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
require_once "config.php";

//Require classes...


include_once "Modules/login/functions/loginClass.php";
include_once "Modules/admin/functions/adminClass.php";
include_once "Modules/message/functions/messageClass.php";
include_once "Modules/forms/functions/formsClass.php";
require_once "Modules/session/functions/sessionClass.php";

//General rule processing....

//Related to data rule processing....

$item_addons=$raw_data["addons"];
$items_addons=$raw_data2["addons"];

$resArray=array();
for($jj=0;$jj<count($conditions);$jj++)
{
	
	//calculate for parameters....
	if ($conditions[$jj]["operand1"]["type"]=="function")
	{
		$op1=eval("return ".$conditions[$jj]["operand1"]["expr"]);
	}
	else
		$op1=$conditions[$jj]["operand1"]["expr"];

	if ($conditions[$jj]["operator"]["type"]=="function")
		$op2=eval("return ".$conditions[$jj]["operator"]["expr"]);
	else
		$op2=$conditions[$jj]["operator"]["expr"];
	
	if ($conditions[$jj]["operand2"]["type"]=="function")
		$op3=eval("return ".$conditions[$jj]["operand2"]["expr"]);
	else
		$op3=$conditions[$jj]["operand2"]["expr"];
	
	$resArray[$jj]=check_condition($op1,$op2,$op3);
}
//check total conditions....
if (count($patterns)>0)
{	
	$expr="";
	for($l=0;$l<count($patterns);$l++)
		$expr.=($resArray[$l]?"true":"false")." ".$patterns[$l]." ".($resArray[$l+1]?"true":"false");

	//do actions on success....
	if (eval("return ".$expr.";"))
	{
		die("hiiii");
	}
	//do actions on failure

	else
	{
		die("by....");
	}
}
else
{
	if($resArray[0]){
		for($i=0;$i<count($actions_success);$i++){
			//die($actions_success[$i]);
			
			eval($actions_success[$i]);
		}
		
	}
	else
		for($i=0;$i<count($actions_failure);$i++)
			//die($actions_failure[$i]);
			eval($actions_failure[$i]);
}	
?>
