<?php
$ini = parse_ini_file("lib/config.ini", true);
$webgl = $ini["ENVIRON"]["webgl"];
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=Edge">
	<script type="text/javascript" src="./extlib/enchant.min.js"></script>
    <meta name="viewport" content="width=device-width, user-scalable=no, minimal-ui">
    <meta name="apple-mobile-web-app-capable" content="yes">
	<script type="text/javascript" src="./extlib/Box2dWeb-2.1.a.3.min.js"></script>
	<script type="text/javascript" src="./extlib/box2d.enchant.js"></script>
<?php   if ($webgl == true) {
?>	<script type="text/javascript" src="./extlib/gl-matrix-min.js"></script>
	<script type="text/javascript" src="./extlib/gl.enchant.js"></script>
	<script type="text/javascript" src="./extlib/primitive.gl.enchant.js"></script>
	<script type="text/javascript" src="./extlib/collada.gl.enchant.js"></script>
	<script type="text/javascript" src="./extlib/mmd.gl.enchant.js"></script>
<?php   }
?>	<script type="text/javascript" src="./extlib/socket.enchant.js"></script>
	<script type="text/javascript" src="./usrobject/environ.js"></script>
	<script type="text/javascript" src="./sysobject/enforce.core.js"></script>
<?php
	$srcdir = "./plugins";
	$dir = opendir($srcdir);
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname) || !preg_match("/.*.js/", $fname)) {
			continue;
		}
		echo "<script type='text/javascript' src='$srcdir/$fname'></script>\n";
	}

	$srcdir = "./usrobject";
	$dir = opendir($srcdir);
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname) || preg_match("/environ.js/", $fname)) {
			continue;
		}
		echo "<script type='text/javascript' src='$srcdir/$fname'></script>\n";
	}
?>
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body bgcolor="black">
</body>
</html>

