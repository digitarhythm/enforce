<?php
	$_HOMEDIR_ = realpath(__DIR__);
	$sid = session_id();
	if ($sid != "") {
		session_regenerate_id();
	} else {
		session_start();
	}
	set_include_path(get_include_path().PATH_SEPARATOR.$_HOMEDIR_."/syslibs");
	require_once("main.php");
	
	if (file_exists($_HOMEDIR_."/Media/Picture/touch-icon.png")) {
		$touchicon = "<link rel='apple-touch-icon' href='Media/Picture/touch-icon.png'>";
	} else {
		$touchicon = "";
	}
	
	// システム定数を読み込む
	$confpath = "$_HOMEDIR_/configs/system.ini";
	$systemini = parse_ini_file($confpath, true);

	$framework = array();
	if (isset($systemini['FRAMEWORKS'])) {
		$includelist = $systemini['FRAMEWORKS'];
		foreach ($includelist as $package) {
			$framework[] = $package;
		}
	}

	if (isset($systemini['APIKEY']['GOOGLEMAPS_V3'])) {
		$googlemaps_v3_apikey = $systemini['APIKEY']['GOOGLEMAPS_V3'];
		$googlemaps_v3_tag = "<script type='text/javascript' src='http://maps.googleapis.com/maps/api/js?key=$googlemaps_v3_apikey&sensor=true'></script>";
	} else {
		$googlemaps_v3_tag = "";
	}
?>
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, minimum-scale=1, maximum-scale=1" />
		<meta name="format-detection" content="telephone=no" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<?php
		if ($touchicon != "") {
			echo $touchicon;
		}
?>
		<link rel="stylesheet" href="syslibs/codeJS_default/jquery-ui-1.10.3.custom.min.css" />
<?php
		if ($googlemaps_v3_tag != "") {
			echo $googlemaps_v3_tag;
		}
?>
		<script type="text/javascript" charset="UTF-8" src="syslibs/jquery-2.0.3.min.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/jquery.finger.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/jquery.cookie.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/jquery-ui.min.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/jquery.ui.touch-punch.min.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/jquery.upload-1.0.2.min.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/imgLiquid-min.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/three.min.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/library.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/JSKit.js"></script>
<?php
		foreach ($framework as $package) {
			$f = "syslibs/frameworks/$package.framework.js";
			clearstatcache();
			if (file_exists($_HOMEDIR_."/".$f) == true) {
?>			<script type="text/javascript" charset="UTF-8" src="<?php echo $f ?>"></script>
<?php
			}
		}
?>		<script type="text/javascript" charset="UTF-8" src="usrlibs/applicationMain.js"></script>
		<script type="text/javascript" charset="UTF-8" src="syslibs/main.js"></script>
<?php
		$link_arr = array();	
		$ext = "js";
		$search_dir = "usrlibs";
		$dir = opendir($_HOMEDIR_."/".$search_dir);
		while ($fname = readdir($dir)) {
			if ($fname != "applicationMain.js" && preg_match("/.*\.".$ext."$/", $fname)) {
				$link_arr[] = $search_dir."/".$fname;
			}
		}
		$search_dir = "Plugins";
		$dir = opendir($_HOMEDIR_."/".$search_dir);
		while ($fname = readdir($dir)) {
			if ($fname != "applicationMain.js" && preg_match("/.*\.".$ext."$/", $fname)) {
				$link_arr[] = $search_dir."/".$fname;
			}
		}
		sort($link_arr);
		foreach ($link_arr as $f) {
?>			<script type="text/javascript" charset="UTF-8" src="<?php echo $f ?>"></script>
<?php
		}
?>
	</head>
	<body marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
	</body>
	</html>
