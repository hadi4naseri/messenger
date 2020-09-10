<?php 
$tempPath=getcwd();

require_once($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/config.php");

$tenant=findTenant($_SERVER['REQUEST_URI']);

chdir($tempPath);
?>