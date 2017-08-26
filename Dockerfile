FROM hardware/debian-mail-overlay:1.6.3

LABEL description "Simple and full-featured mail server using Docker" \
      maintainer="Hardware <contact@meshup.net>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    postfix postfix-mysql postfix-pcre libsasl2-modules \
    dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql dovecot-sieve dovecot-managesieved dovecot-pop3d \
    fetchmail libdbi-perl libdbd-mysql-perl liblockfile-simple-perl \
    clamav-daemon \
    python-pip python-setuptools python-gpgme \
    rsyslog dnsutils curl sudo unbound \
 && rm -rf /var/spool/postfix \
 && ln -s /var/mail/postfix/spool /var/spool/postfix \
 && pip install envtpl \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/debconf/*-old

VOLUME /var/mail /etc/letsencrypt
EXPOSE 25 143 465 587 993 4190
COPY rootfs /
RUN chmod +x /usr/local/bin /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*
CMD ["run.sh"]
