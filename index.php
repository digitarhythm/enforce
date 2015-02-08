<?php
$ini = parse_ini_file("lib/config.ini", true);
$library = $ini['ENVIRON']['LIBRARY'];
$webgl = $ini['ENVIRON']['WEBGL'];
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=Edge">
    <meta property="og:title" content="enforce games.">
    <meta property="og:image" content="lib/enforce_icon.png">
<?php
    if ($library == "enchant") {
?>
        <script type="text/javascript" src="extlib/enchant.0.8.1-enforce.min.js"></script>
        <script type="text/javascript" src="extlib/ui.enchant-enforce.js"></script>
        <script type="text/javascript" src="extlib/extendMap.enchant.js"></script>
<?php
    }
?>
    <meta name="viewport" content="width=device-width, user-scalable=no, minimal-ui">
    <meta name="apple-mobile-web-app-capable" content="yes">
	<script type="text/javascript" src="usrobject/environ.js"></script>
<?php
    if ($library == "enchant") {
?>
        <script type="text/javascript" src="extlib/Box2dWeb-2.1.a.3.min.js"></script>
        <script type="text/javascript" src="extlib/box2d.enchant.js"></script>
        <script type="text/javascript" src="extlib/socket.io-1.3.0.js"></script>
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
        <script type="text/javascript" src="sysobject/enforce.core.js"></script>
<?php
    } else if ($library == "tmlib") {
?>
        <script type="text/javascript" src="extlib/tmlib.min.js"></script>
        <script type="text/javascript" src="sysobject/enforce.core2.js"></script>
<?php
    }
    if ($webgl == true) {
?>
        <script type="text/javascript">
            WEBGL = true;
        </script>
<?php
    } else {
?>
        <script type="text/javascript">
            WEBGL = false;
        </script>
<?php
    }
    // #################################################################################
    // プラグインスクリプト読み込み
    // #################################################################################
	$srcdir = "./plugins";
	$dir = opendir($srcdir);
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname) || preg_match("/environ.js/", $fname)) {
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
<body bgcolor="#303030">
<?php
    if ($library == "tmlib") {
?>
        <canvas id="stage"></canvas>
<?php
    }
?>
</body>
</html>
