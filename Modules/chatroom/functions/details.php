<?php 
$tempPath=getcwd();

require_once($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/config.php");
chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/Modules/news/");
require_once("newsClass.php");

$tenant=findTenant($_SERVER['REQUEST_URI']);
news::show_details($_GET["handle"],$_GET['id']);

chdir($tempPath);
?>