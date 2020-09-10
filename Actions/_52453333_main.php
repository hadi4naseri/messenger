<?php

chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
require_once "config.php";

//Require classes...

require_once "Modules/counter/functions/counterClass.php";

//General rule processing....

//Related to data rule processing....

$item_addons=$raw_data["addons"];
$items_addons=json_decode(select($tenant,$raw_data["name"],array("id"=>1,"addons"=>1),array()),true);

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
	
	//die(print_r($op1));
	$resArray[$jj]=check_condition($op1,$op2,$op3);
}

//check total conditions....
$expr="";
for($l=0;$l<count($patterns);$l++)
	$expr.=($resArray[$l]?"true":"false")." ".$patterns[$l]." ".($resArray[$l+1]?"true":"false");

//do actions on success....
if (eval("return ".$expr.";"))
{
	//die("hiiii");
}
//do actions on failure

else
{
	die("gggg");
}
?>
