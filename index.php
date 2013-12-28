<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <script type="text/javascript" src="enchant.js"></script>
    <script type="text/javascript" src="library.js"></script>
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
    <script type="text/javascript" src="main.js"></script>
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

