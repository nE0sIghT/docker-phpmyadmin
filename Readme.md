phpMyAdmin Docker image
============================================
Introduction
------------

This repository contains source code for simple php-cli driven phpMyAdmin Docker image.  
This image is suitable for running in Openshift/Kubernetes.  
phpMyAdmin is exposed on port 8080.

Runtime environment variable
------------
 * **PMA_PORT** - phpMyAdmin TCP port. Default - 8080.
 * **MYSQL_HOST** - address of MySQL server.
 * **MYSQL_PORT** - port of MySQL server. Default - 3306.
