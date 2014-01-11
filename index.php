<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="x-ua-compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <script type="text/javascript" src="environ.js"></script>
<?php
	$srcdir = "./extlib";
	$dir = opendir($srcdir);
	$plugin = [];
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname) || !preg_match("/.*\.js$/", $fname)) {
			continue;
		}
		$plugin[] = $fname;
	}
	sort($plugin);
	foreach ($plugin as $f) {
		echo "<script type='text/javascript' src='$srcdir/$f'></script>";
	}

	$srcdir = "./sysobject";
	$dir = opendir($srcdir);
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname)) {
			continue;
		}
		echo "<script type='text/javascript' src='$srcdir/$fname'></script>";
	}

	$srcdir = "./usrobject";
	$dir = opendir($srcdir);
	while ($fname = readdir($dir)) {
		if (is_dir($srcdir."/".$fname) || preg_match("/stationary.js/", $fname)) {
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

