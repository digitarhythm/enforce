<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <script type="text/javascript" src="lib/enchant.js"></script>
    <script type="text/javascript" src="lib/library.js"></script>
    <script type="text/javascript" src="environ.js"></script>
    <script type="text/javascript" src="lib/main.js"></script>
    <script type="text/javascript" src="lib/originSprite.js"></script>
<?php
	$srcdir = "./classobject";
	$dir = opendir($srcdir);
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname)) {
			continue;
		}
		echo "<script type='text/javascript' src='$srcdir/$fname'></script>";
	}
?>
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
</body>
</html>

