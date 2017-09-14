#!/usr/bin/env sh

# =============================================================================
# Check that /data is a volume mount

if ! grep -qE ' /data ' /proc/mounts; then
	echo "Error: /data is not a volume!" 1>&2
	exit 1
fi

# =============================================================================
# Be sure the needed structure is in /data

for DIR in certs:root clamav:clamav db:mail etc:root mail:mail queue:mail spamassassin:mail; do
	DIR_PATH="$(echo "${DIR}" | cut -d : -f 1)"
	DIR_USER="$(echo "${DIR}" | cut -d : -f 2)"
	if [ ! -d "/data/${DIR_PATH}" ]; then
		if [ -e "/data/${DIR_PATH}" ]; then
			echo "Warning: /data/${DIR_PATH} exists, but it's not a directory" 1>&2
			echo "Notice: Removing /data/${DIR_PATH} to make room for the directory" 1>&2
			rm -f "/data/${DIR_PATH}"
		fi
		echo "Info: Creating /data/${DIR_PATH}"
		mkdir "/data/${DIR_PATH}"
	fi
	if [ -n "${DIR_USER}" ]; then
		chown -R "${DIR_USER}" "/data/${DIR_PATH}"
	fi
done

# =============================================================================
# Does the database exist

if [ -e /data/db/mail.db ] && ! sqlite3 /data/db/mail.db .tables 2>/dev/null >/dev/null; then
	echo "Warning: /data/db/mail.db exists, but it's not an sqlite3 database" 1>&2
	echo "Notice: Removing /data/db/mail.db to make room for the real database" 1>&2
	rm -rf /data/db/mail.db
fi
if [ ! -f /data/db/mail.db ]; then
	echo "Info: Creating /data/db/mail.db"
	sqlite3 /data/db/mail.db < /opt/postman/schema/mail.sql

	echo "Notice: Importing any on-disk mailboxes into the database" 1>&2
	# shellcheck disable=SC2164
	cd /data/mail
	find . -mindepth 1 -maxdepth 1 -type d | sed 's/^\.\///' | while read -r DOMAIN; do
		echo "Info: Creating domain record: ${DOMAIN}"
		sqlite3 /data/db/mail.db "INSERT INTO domains (name, notes) VALUES ('${DOMAIN}', 'Automatically imported');"
		# shellcheck disable=SC2164
		cd "/data/mail/${DOMAIN}"
		find . -mindepth 1 -maxdepth 1 -type d | sed 's/^\.\///' | while read -r MAILBOX; do
			echo "Info: Creating mailbox record: ${MAILBOX}@${DOMAIN}"
			sqlite3 /data/db/mail.db "INSERT INTO mailboxes (domain_name, name, readable, notes) VALUES ('${DOMAIN}', '${MAILBOX}', 0, 'Automatically imported');"
		done
	done
fi

# =============================================================================
# Are there SpamAssassin rules

if [ ! -e /var/lib/spamassassin/3.004001 ] || [ ! -L /var/lib/spamassassin ]; then
	rm -rf /var/lib/spamassassin
	ln -s /data/spamassassin /var/lib/spamassassin
fi

if [ -z "$(ls -1 /data/spamassassin)" ]; then
	sa-update
fi


# =============================================================================
# Fire up supervisor to do everything else

exec /usr/bin/supervisord --configuration /etc/supervisord.conf
