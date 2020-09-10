<?php
	function tenantLoad()
	{
		
		$tempPath=getcwd();
		chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
		require_once "config.php";
				
		require_once "/Modules/logging/loggingClass.php";
		//require_once "/Modules/system/systemClass.php";
		
		//logging::createLog(findTenant($_SERVER["SCRIPT_FILENAME"]),array("message"=>"Tenant loaded at :".system::systemTime()));
		
	}
	