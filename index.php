<?php
$ini = parse_ini_file("lib/config.ini", true);
$webgl = $ini['ENVIRON']['WEBGL'];
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=Edge">
    <script type="text/javascript" src="extlib/enchant.0.8.1-enforce.js"></script>
    <meta name="viewport" content="width=device-width, user-scalable=no, minimal-ui">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <script type="text/javascript" src="extlib/jquery-2.1.0.min.js"></script>
    <script type="text/javascript" src="extlib/jquery.cookie.js"></script>
    <script type="text/javascript" src="extlib/Box2dWeb-2.1.a.3.min.js"></script>
    <script type="text/javascript" src="extlib/box2d.enchant.js"></script>
<?php
    if ($webgl == true) {
?>
        <script type="text/javascript" src="extlib/gl-matrix-min.js"></script>
        <script type="text/javascript" src="extlib/gl.enchant.js"></script>
        <script type="text/javascript" src="extlib/primitive.gl.enchant.js"></script>
        <script type="text/javascript" src="extlib/collada.gl.enchant.js"></script>
        <script type="text/javascript" src="extlib/mmd.gl.enchant.js"></script>
<?php
    }
?>
    <script type="text/javascript" src="extlib/socket.enchant.js"></script>
    <script type="text/javascript" src="sysobject/enforce.core.js"></script>
	<script type="text/javascript" src="usrobject/environ.js"></script>
<?php
    if ($webgl == true) {
?>
        <script type/javascript">
            WEBGL = true;
        </script>
<?php
    } else {
?>
        <script type/javascript">
            WEBGL = false;
        </script>
<?php
    }
    // #################################################################################
    // ユーザーライブラリー読み込み
    // #################################################################################
	$srcdir = "./plugins";
	$dir = opendir($srcdir);
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname) || !preg_match("/.*.js/", $fname)) {
			continue;
		}
		echo "<script type='text/javascript' src='$srcdir/$fname'></script>\n";
	}

    // #################################################################################
    // アプリケーションスクリプト読み込み
    // #################################################################################
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
<body bgcolor="gray">
</body>
</html>
