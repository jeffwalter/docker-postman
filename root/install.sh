#!/usr/bin/env sh

# =============================================================================
# Update package lists
apk update

# =============================================================================
# Install packages

# Supervisor
apk add supervisor
# sqlite
apk add sqlite
# ClamAV
apk add clamav
# SpamAssassin
apk add spamassassin
apk add spamassassin-client
# PHP
apk add php7-fpm
apk add php7-imap
apk add php7-json
apk add php7-mcrypt
apk add php7-opcache
apk add php7-pdo_sqlite
apk add php7-session
# Dovecot
apk add dovecot
apk add dovecot-sqlite
# Exim
apk add exim
apk add exim-scripts
apk add exim-sqlite
apk add exim-utils
# nginx
apk add nginx

# =============================================================================
# Add dovecot to the mail group

cp /etc/group /opt/dist/etc/
awk '{skip=0;} /^mail:/{printf("%s,dovecot\n",$0);skip=1;}{if(skip==0){print $0;}else{skip=0;}}' /opt/dist/etc/group >/etc/group

# =============================================================================
# Remove new package configuration and symlink to our own

# shellcheck disable=SC2164
cd /opt/postman/etc
find . -mindepth 1 -maxdepth 1 | sed -e 's/^\.\///' | while read -r FILE; do
	if [ -e "/etc/${FILE:?}" ]; then
		mv "/etc/${FILE:?}" /opt/dist/etc/
	fi
	ln -s "/opt/postman/etc/${FILE}" "/etc/${FILE:?}"
done

# =============================================================================
# Remove package lists

rm /var/cache/apk/*

# =============================================================================
# Remove self

rm /install.sh

