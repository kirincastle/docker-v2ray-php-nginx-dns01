<?php
if(isset($_GET['size']))
{
  $size=$_GET['size'];
  // Disable Compression
  @ini_set('zlib.output_compression', 'Off');
  @ini_set('output_buffering', 'Off');
  @ini_set('output_handler', '');
  // Headers
  header('HTTP/1.1 200 OK');
  // Download follows...
  header('Content-Description: File Transfer');
  header('Content-Type: application/octet-stream');
  header('Content-Disposition: attachment; filename=random_'.$size.'k.dat');
  header('Content-Transfer-Encoding: binary');
  // Never cache me
  header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
  header('Cache-Control: post-check=0, pre-check=0', false);
  header('Pragma: no-cache');
  // Generate data
  $data_1k=openssl_random_pseudo_bytes(1024*1024);
  
  $size_sended=$size%1024;
  if ($size_sended>0)
  {
    echo openssl_random_pseudo_bytes($size_sended*1024);
    flush();
  }

  while ( $size_sended < $size )
  {
    echo $data_1k;
    flush();
    $size_sended=$size_sended+1024;
  }
  

  exit();
}
if(isset($_GET['r']))
{
  print $_GET['r'];
  exit();
}
print_r($_SERVER);
?>