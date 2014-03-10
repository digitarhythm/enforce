<?php
// setup directory
$_HOMEDIR_ = realpath(__DIR__."/..");
$_DOCDIR_ = $_HOMEDIR_."/Documents";

// parse ini file
$ini = parse_ini_file($_HOMEDIR_."/configs/system.ini");

// add library include path
set_include_path(get_include_path().PATH_SEPARATOR.$_HOMEDIR_."/syslibs");
