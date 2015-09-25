FROM debian:jessie

RUN groupadd -g 48 ftp && \
    useradd --no-create-home --home-dir /srv -s /bin/false --uid 48 --gid 48 -c 'ftp daemon' ftp

RUN apt-get update \
    && apt-get install -y --no-install-recommends vsftpd db5.3-util whois \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty /etc/vsftpd/user_conf /var/ftp /srv && \
    touch /var/log/vsftpd.log && \
    rm -rf /srv/ftp

COPY vsftpd*.conf /etc/
COPY vsftpd_virtual /etc/pam.d/
COPY *.sh /

VOLUME ["/etc/vsftpd", "/srv"]

EXPOSE 21 4559 4560 4561 4562 4563 4564

ENTRYPOINT ["/entry.sh"]
CMD ["vsftpd"]