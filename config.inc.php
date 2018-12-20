<?php
$cfg['blowfish_secret'] = '$PMA_SECRET';

/*
 * Servers configuration
 */
$i = 0;

/*
 * First server
 */
$i++;
/* Authentication type */
$cfg['Servers'][$i]['auth_type'] = 'cookie';
/* Server parameters */
$cfg['Servers'][$i]['host'] = '$MYSQL_HOST';
$cfg['Servers'][$i]['port'] = $MYSQL_PORT;
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = true;
$cfg['Servers'][$i]['AllowNoPassword'] = true;
