<?php
require_once("main.php");

if (!isset($_REQUEST['mode'])) {
	return;
}

$_arg = array();
foreach ($_REQUEST as $key => $val) {
	if (is_array($val) == true) {
		$arr = array();
		foreach ($val as $val2) {
			$arr[] = strip_tags($val2);
		}
		$_arg[$key] = $arr;
	} else {
		$_arg[$key] = strip_tags($val);
	}
}

$_file = procarray($_FILES);

function procarray($arr) {
	$ret = array();
	foreach ($arr as $key => $val) {
		if (is_array($val) == true) {
			$val = procarray($val);
		} else {
			$val = htmlspecialchars($val);
		}
		$ret[$key] = $val;
	}
	return $ret;
}

$mode = $_arg["mode"];
switch ($mode) {
	case "compile":
		exec("coffee -b -o ../../usrobject -c ../../src/*.coffee 2>&1", $output, $retcode);
		if ($output != 0) {
			$retstr = join("\n", $output);
		} else {
			$retstr = "";
		}
		echo $retstr;
		break;

	case "derive":
		$classname = $_arg["name"];
		$str = file_get_contents($_HOMEDIR_."/syslibs/stationary.coffee");
		$str = preg_replace("/\[__classname__\]/", $classname, $str);
		if (is_file($_HOMEDIR_."/Documents/src/".$classname.".coffee") == false) {
			$fp = fopen($_HOMEDIR_."/Documents/src/".$classname.".coffee", "w");
			fputs($fp, $str);
		}
        break;

    case "website":
        $uri = $_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
        echo $uri;
        break;
}
?>
