FROM phpmyadmin/phpmyadmin

LABEL author="Yuri Konotopov <ykonotopov@gnome.org>"

RUN set -ex \
	&& useradd -u 1000 -U -M -r phpmyadmin \
	&& sed -i -e 's/80/8080/g' /etc/apache2/ports.conf \
	&& sed -i -e 's/80/8080/g' /etc/apache2/sites-available/000-default.conf \
	&& chown phpmyadmin:root -R /etc/phpmyadmin /var/www/html/tmp \
	&& chmod 0770 /etc/phpmyadmin /var/www/html/tmp

USER phpmyadmin
