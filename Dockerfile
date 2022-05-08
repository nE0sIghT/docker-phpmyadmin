FROM phpmyadmin/phpmyadmin

LABEL author="Yuri Konotopov <ykonotopov@gnome.org>"

RUN set -ex \
	&& useradd -u 1000 -U -M -r phpmyadmin \
	&& sed -i -e 's/80/8080/g' /etc/apache2/ports.conf \
	&& sed -i -e 's/80/8080/g' /etc/apache2/sites-available/000-default.conf \
	&& sed -i -e '/max_execution_time/d' $PHP_INI_DIR/conf.d/* \
	&& echo "upload_max_filesize=1G" > $PHP_INI_DIR/conf.d/upload.ini \
	&& echo "post_max_size=1G" >> $PHP_INI_DIR/conf.d/upload.ini \
	&& echo "max_execution_time=0" >> $PHP_INI_DIR/conf.d/upload.ini \
	&& echo "<?php\n\$cfg['ExecTimeLimit'] = 0;" > /etc/phpmyadmin/config.user.inc.php \
	&& chown phpmyadmin:phpmyadmin -R /etc/phpmyadmin

USER 1000
