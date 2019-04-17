<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_uptime()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `uptime` (
                              `ID` INT(11) NOT NULL AUTO_INCREMENT,
                              `HARDWARE_ID` INT(11) NOT NULL,
                              `TIME` VARCHAR(64) DEFAULT NULL,
                              `DURATION` VARCHAR(255) DEFAULT NULL,
                              PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                              ) ENGINE=INNODB ;");
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_uptime()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE `uptime`;");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_uptime()
{

}
