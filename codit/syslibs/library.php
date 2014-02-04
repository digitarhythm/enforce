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
    case "stringWithContentsOfFile":
        $fname = $_arg["fname"];
        $ret = stringWithContentsOfFile($fname);
        echo $ret;
        break;

    case "writeToFile":
        $fname = $_REQUEST["fname"];
        $data = $_REQUEST["data"];
        $ret = writeToFile($data, $fname);
        echo $ret;
        break;

    case "filelist":
        $path = $_arg["path"];
        $filter = $_arg["filter"];
        $ret = filelist($path, $filter);
        echo JSON_encode($ret);
        break;

    case "uploadfile":
        $ret = saveImageFile($_file, $_arg);
        echo $ret;
        break;
    
    case "createThumbnail":
        $path = $_arg["path"];
        createThumbnail($path);
        break;
    
    case "thumbnailList":
        $path = $_arg["path"];
        $ret = thumbnailList($path);
        echo JSON_encode($ret);
        break;

    case "fileUnlink":
        $fpath = $_arg["fpath"];
        unlink($_HOMEDIR_."/".$fpath);
        echo $fpath;
        break;
    
    case "savePicture":
        $imagepath = $_arg['imagepath'];
        $fpath = $_arg['fpath'];
        $ret = savePicture($imagepath, $fpath);
        echo $ret;
        break;
    
    case "removeFile":
        $path = $_arg['path'];
        $ret = removeFile($path);
        echo $ret;
        break;
    
    case "moveFile":
        $file = $_arg['file'];
        $toPath = $_arg['toPath'];
        $ret = moveFile($file, $toPath);
        echo $ret;
        break;

    case "setUserDefaults":
        $value = $_arg['value'];
        $forKey = $_arg['forKey'];
        $ret = setUserDefaults($value, $forKey);
        echo $ret;
        break;
    
    case "getUserDefaults":
        $forKey = $_arg['forKey'];
        $ret = getUserDefaults($forKey);
        echo $ret;
        break;
    
    case "removeUserDefaults":
        $forKey = $_arg['forKey'];
        $ret = removeUserDefaults($forKey);
        echo $ret;
        break;

    case "createDirectoryAtPath":
        $path = $_arg['path'];
        $ret = createDirectoryAtPath($path);
        echo $ret;
        break;
}

//##########################################################################################
//##########################################################################################
//##########################################################################################

//##########################################################################################
// 指定されたファイルを読み込む
//##########################################################################################
function stringWithContentsOfFile($fname) {
    global $_HOMEDIR_;
    $str = file_get_contents($_HOMEDIR_."/".$fname);
    return $str;
}

//##########################################################################################
// 渡されたデータを指定されたファイル名で保存する
//##########################################################################################
function writeToFile($data, $fname) {
    global $_HOMEDIR_;
    
    $fullpath = $_HOMEDIR_."/".$fname;
    $path = pathinfo($fullpath, PATHINFO_DIRNAME);
    if (is_dir($path) == false) {
        mkdir($path, 0775, true);
    }
    $fp = fopen($fullpath, "w");
    if ($fp == null) {
        return "0";
    }
    fputs($fp, $data);
    fclose($fp);
    return "1";
}

//##########################################################################################
// アップロードされた画像を保存する
//##########################################################################################
function saveImageFile($_file, $_dir) {
    global $_HOMEDIR_;
    
    $imginfo = $_file[$_dir['key']];
    $tmpname = $imginfo['tmp_name'];
    $type = $imginfo['type'];
    $orgname = $imginfo['name'];
    
    $savedir = $_HOMEDIR_."/Media/Picture";
    switch ($type) {
        case "image/png":
            $ext = ".png";
            break;
        case "image/jpg":
            $ext = ".jpg";
            break;
        case "image/jpeg":
            $ext = ".jpg";
            break;
        case "image/gif":
            $ext = ".gif";
            break;
        default:
            return "{path:'', err:0}";
            break;
    }
    
    if(is_uploaded_file($tmpname)){
        $temppath = tempnam($savedir, "img_");
        $savepath = $temppath.$ext;
        $fname = basename($savepath);
        move_uploaded_file($tmpname, $savepath);
        unlink($temppath);
        return "{path:'".$fname."', err:1}";
    } else {
        return "{path:'', err:0}";
    }
}

//##########################################################################################
// 指定したパスのファイルリストを返す
//##########################################################################################
function filelist($path, $filter)
{
    global $_HOMEDIR_;
    $dir = opendir($_HOMEDIR_."/".$path);
    $result_f = array();
    $result_d = array();
    while ($fname = readdir($dir)) {
        $target = "$_HOMEDIR_/$path/$fname";
        if (is_dir($target) == true) {
            if (!preg_match("/^\./", $fname)) {
                $result_d[] = $fname;
            }
        } else {
            $ext = pathinfo($fname, PATHINFO_EXTENSION);
            if (in_array($ext, $filter) == true) {
                $result_f[] = $fname;
            }
        }
    }
    $result = array();
    $result["file"] = $result_f;
    $result["dir"] = $result_d;
    return $result;
}

//##########################################################################################
// サムネイルリストを返す
//##########################################################################################
function thumbnailList($path)
{
    deleteAloneThumb($path);
    global $_HOMEDIR_;
    $thumbdir = $_HOMEDIR_."/$path/.thumb";
    $dir = opendir($_HOMEDIR_."/".$path);
    $result_f = array();
    $result_d = array();
    $extarray = array("png", "jpg", "jpeg", "gif");
    while ($fname = readdir($dir)) {
        $target = "$_HOMEDIR_/$path/$fname";
        if (is_dir($target) == false && !preg_match("/^\..*/", $fname)) {
            $ext = pathinfo($fname, PATHINFO_EXTENSION);
            $file = pathinfo($fname, PATHINFO_FILENAME);
            if (in_array($ext, $extarray) == true && is_file($thumbdir."/".$file."_s.".$ext) == true) {
                $result_f[] = $path."/.thumb/".$file."_s.".$ext;
            } else {
                $result_f[] = $path."/".$fname;
            }
        }
    }
    $result = array();
    $result["file"] = $result_f;
    $result["dir"] = $result_d;
    return $result;
}

//##########################################################################################
// 指定したパスにある画像のサムネイルを生成する
//##########################################################################################
function createThumbnail($path)
{
    global $_HOMEDIR_;
    $imgdir = $_HOMEDIR_."/$path";
    $thumbdir = $_HOMEDIR_."/$path/.thumb";
    if (is_dir($thumbdir) == false) {
        return 0;
    }
    $extarray = array("png", "jpg", "jpeg", "gif");
    $dir = opendir($_HOMEDIR_."/".$path);
    while ($fname = readdir($dir)) {
        $ext = pathinfo($fname, PATHINFO_EXTENSION);
        $file = pathinfo($fname, PATHINFO_FILENAME);
        if (in_array($ext, $extarray) == true && is_file($thumbdir."/".$file."_s.".$ext) == false) {
            exec("convert -resize 120x120 ".$imgdir."/".$fname." ".$thumbdir."/".$file."_s.".$ext);
        }
    }
    deleteAloneThumb($path);
}

//##########################################################################################
// 指定したディレクトリの画像で、親画像が無くなっているサムネイル画像を削除する
//##########################################################################################
function deleteAloneThumb($path)
{
    global $_HOMEDIR_;
    $imgdir = $_HOMEDIR_."/$path";
    $thumbdir = $_HOMEDIR_."/$path/.thumb";
    if (is_dir($thumbdir) == false) {
        return 0;
    }
    $dir = opendir($thumbdir);
    while ($fname = readdir($dir)) {
        $ext = pathinfo($fname, PATHINFO_EXTENSION);
        $filetmp = pathinfo($fname, PATHINFO_FILENAME);
        preg_match("/(.*)_s/", $filetmp, $match);
        if (isset($match[1]) == false) {
            continue;
        }
        if (is_file($imgdir."/".$match[1].".".$ext) == false) {
            unlink($thumbdir."/".$fname);
        }
    }
}

//##########################################################################################
// 指定された画像ファイルを指定されたパスにコピーする
//##########################################################################################
function savePicture($imagepath, $path)
{
    global $_HOMEDIR_;
    
    if (is_file($_HOMEDIR_."/".$imagepath) == false) {
        return $imagepath;
    }
    
    $ret = copy($_HOMEDIR_."/".$imagepath, $_HOMEDIR_."/".$path);
    
    return $ret;
}

//##########################################################################################
// 指定されたファイルを削除する
//##########################################################################################
function removeFile($path)
{
    global $_HOMEDIR_;
    
    $fullpath = $_HOMEDIR_."/".$path;
    if (is_file($fullpath) || is_dir($fullpath)) {
        $err = system("rm -rf ".$fullpath);
        if ($err == false) {
            $ret = 0;
        } else {
            $ret = 1;
        }
    } else {
        $ret = 1;
    }
    
    return $ret;
}

//##########################################################################################
// 指定されたファイルを移動する
//##########################################################################################
function moveFile($file, $toPath)
{
    global $_HOMEDIR_;
    
    $orgFullPath = $_HOMEDIR_."/".$file;
    $toFullPath = $_HOMEDIR_."/".$toPath;
    if (is_file($orgFullPath)) {
        $err = rename($orgFullPath, $toFullPath);
        if ($err == false) {
            $ret = 0;
        } else {
            $ret = 1;
        }
    } else {
        $ret = 0;
    }
    
    return $ret;
}

//##########################################################################################
// 指定されたユーザーデフォルト値を保存する
//##########################################################################################
function setUserDefaults($value, $forKey)
{
    global $_HOMEDIR_;
    
    try {
        $dbh = new PDO('sqlite:'.$_HOMEDIR_.'/Library/sqlite3.db');
        $sth = $dbh->prepare('SELECT forKey,value FROM user_defaults WHERE forKey=?');
        $sth->execute(array($forKey));
        $result = $sth->fetchAll();
        $sth->closeCursor();
        
        $dbh = new PDO('sqlite:'.$_HOMEDIR_.'/Library/sqlite3.db');
        if (isset($result[0]['forKey'])) {
            $sth = $dbh->prepare('UPDATE user_defaults SET value=? WHERE forKey=?');
            $sth->execute(array($value, $forKey));
        } else {
            $sth = $dbh->prepare('INSERT INTO user_defaults(forkey, value) VALUES(?, ?)');
            $sth->execute(array($forKey, $value));
        }
        $sth->closeCursor();
        
        $ret = "1";
    } catch( PDOException $e ) {
         $ret = "-1";
    }
    
    return $ret;
}

//##########################################################################################
// 指定されたキーのユーザーデフォルト値を返す
//##########################################################################################
function getUserDefaults($forKey)
{
    global $_HOMEDIR_;
    
    try {
        $dbh = new PDO('sqlite:'.$_HOMEDIR_.'/Library/sqlite3.db');
        $sth = $dbh->prepare('SELECT value FROM user_defaults WHERE forKey=?');
        $sth->execute(array($forKey));
        $result = $sth->fetchAll();
        $sth->closeCursor();
        
        if (isset($result[0]['value'])) {
            $ret = $result[0]['value'];
        } else {
            $ret = "";
        }
    } catch( PDOException $e ) {
         $ret = "";
    }
    
    return $ret;
}

//##########################################################################################
// 指定されたキーのユーザーデフォルト値を消す
//##########################################################################################
function removeUserDefaults($forKey)
{
    global $_HOMEDIR_;
    
    try {
        $dbh = new PDO('sqlite:'.$_HOMEDIR_.'/Library/sqlite3.db');
        $sth = $dbh->prepare('DELETE FROM user_defaults WHERE forKey=?');
        $sth->execute(array($forKey));
        $sth->closeCursor();
        $ret = "1";
    } catch( PDOException $e ) {
         $ret = "-1";
    }
    
    return $ret;
}

//##########################################################################################
// 指定されたディレクトリを作成する
//##########################################################################################
function createDirectoryAtPath($path)
{
    global $_HOMEDIR_;
    
    $fullpath = $_HOMEDIR_."/".$path;
    if (is_file($fullpath) || is_dir($fullpath)) {
        $ret = 0;
    } else {
        $err = system("mkdir -p ".$fullpath);
        if ($err == false) {
            $ret = 0;
        } else {
            $ret = 1;
        }
    }
    
    return $ret;
}
?>
