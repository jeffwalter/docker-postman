FROM alpine:edge

VOLUME ["/data"]

COPY root/ /
RUN /install.sh

#LABEL services="tcp/25,tcp/110,tcp/143,tcp/465,tcp/587,tcp/993,tcp/995"
#LABEL admin="tcp/80"

#EXPOSE 25 80 110 143 465 587 993 995

#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --smtp 25
#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --pop3 110
#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --imap 143
#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --tls --smtp 465
#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --smtp 587
#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --tls --imap 993
#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --tls --pop3 995
#HEALTHCHECK --interval=30s --timeout=5s CMD /opt/postman/bin/healthcheck.sh --http 80

STOPSIGNAL SIGINT
CMD ["/opt/postman/bin/start.sh"]
