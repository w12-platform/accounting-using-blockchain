<?php

$url = 'http://185.5.249.203:8080/setRecord';


  $nonce = round(microtime(true)*10000);

  $data = array(
    'key' => 999,
    'user_id' => 1,
    'data' => 'test data',
    'nonce' => $nonce,
    'hash' => '123',
  );

  $ch = curl_init($url);
  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
  curl_setopt($ch, CURLOPT_TIMEOUT, 30);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
  curl_setopt($ch, CURLINFO_HEADER_OUT, true);

  curl_setopt($ch, CURLOPT_POST, true);
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));

  $result = curl_exec($ch);
  $curl_getinfo = curl_getinfo($ch);

  echo '<pre>';
  print_r($result);
  print_r($curl_getinfo);
  echo '</pre>';