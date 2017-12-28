<?php
function plugin_version_uptime()
{
return array('name' => 'uptime',
'version' => '1.1',
'author'=> 'Guillaume PRIOU, Gilles DUBOIS',
'license' => 'GPLv2',
'verMinOcs' => '2.2');
}

function plugin_init_uptime()
{
$object = new plugins;
$object -> add_cd_entry("uptime","other");

// Officepack table creation

$object -> sql_query("CREATE TABLE IF NOT EXISTS `uptime` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `HARDWARE_ID` INT(11) NOT NULL,
  `TIME` VARCHAR(64) DEFAULT NULL,
  `DURATION` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (`ID`,`HARDWARE_ID`)
) ENGINE=INNODB ;");

}

function plugin_delete_uptime()
{
$object = new plugins;
$object -> del_cd_entry("uptime");

$object -> sql_query("DROP TABLE `uptime`;");

}

?>
