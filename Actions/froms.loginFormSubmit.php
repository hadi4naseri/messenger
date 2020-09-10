<?php
	function loginForm($data)
	{
		
		$tempPath=getcwd();
		chdir($_SERVER["DOCUMENT_ROOT"]."Mobina_new_master/Public/");
		require_once "config.php";
		
		require_once "/Modules/system/systemClass.php";
		
		parse_str($data[0], $qs_array);
		
		if (system::hourOfDay() >= 0 && system::hourOfDay() <24)
			return system::simple_login(findTenant($_SERVER["SCRIPT_FILENAME"]),$qs_array["uname"],$qs_array["pass"]);
		else{
			echo "loginTimeViolation";
			exit;
		}
	}
	