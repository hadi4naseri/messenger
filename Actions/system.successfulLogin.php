<?php
	function registerSession($data)
	{
		//data[0]=>tenant,$data[1]=>uname,data[2]=>name,data[3]=>id
		$tempPath=getcwd();
		chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
		require_once "config.php";
				
		require_once "/Modules/logging/loggingClass.php";
		
		logging::createLog($data[0],array("message"=>$data[1]." was successful login at :".system::systemTime()));
		system::registerSession($data[0],$data[1],$data[2],$data[3]);
	}
	