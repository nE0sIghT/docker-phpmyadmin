FROM php:7.3-cli-stretch

MAINTAINER Yuri Konotopov <ykonotopov@gnome.org>

ENV PHPMYADMIN_VERSION=4.9.2 \
	GPG_KEY=3D06A59ECE730EB71B511C17CE752F178259BD92

COPY config.inc.php /tmp
COPY pma.sh /

RUN set -ex \
        && apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		gettext-base \
		dirmngr \
		gnupg2 \
		apt-transport-https \
		ca-certificates \
		libbz2-dev \
		libfreetype6-dev \
		libjpeg62-turbo \
	        libjpeg62-turbo-dev \
	        libpng16-16 \
	        libpng-dev \
	        libzip-dev \
	&& docker-php-ext-configure bz2 \
	&& docker-php-ext-install -j$(nproc) bz2 \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-configure mysqli \
	&& docker-php-ext-install -j$(nproc) mysqli \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-install -j$(nproc) zip \
	&& apt-get remove --purge --auto-remove -y \
		libbz2-dev \
		libfreetype6-dev \
                libjpeg62-turbo-dev \
                libpng-dev \
        && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
	&& curl -o phpmyadmin.tar.xz "https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.xz" \
	&& curl -o phpmyadmin.tar.xz.asc "https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	|| exit 1 \
	&& found=''; \
	for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
		hkp://p80.pool.sks-keyservers.net:80 \
		pgp.mit.edu \
	; do \
		echo "Fetching GPG key $GPG_KEY from $server"; \
		gpg --batch --keyserver $server --recv-keys "$GPG_KEY" && found=yes && break; \
	done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEY" && exit 1; \
	gpg --batch --verify phpmyadmin.tar.xz.asc phpmyadmin.tar.xz \
	&& { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
	&& rm -r "$GNUPGHOME" phpmyadmin.tar.xz.asc \
	&& apt-get remove --purge --auto-remove -y dirmngr gnupg2 apt-transport-https ca-certificates && rm -r /var/lib/apt/lists/* \
	&& mkdir -p /usr/share/phpmyadmin \
	&& tar -xJC /usr/share/phpmyadmin --strip-components=1 -f phpmyadmin.tar.xz \
	&& rm phpmyadmin.tar.xz \
	&& chmod g+w /usr/share/phpmyadmin

CMD ["/pma.sh"]
