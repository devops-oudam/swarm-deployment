FROM haproxy:1.7-alpine

COPY ./ /

RUN chmod 755 /clik-entrypoint.sh
ENTRYPOINT [ "/clik-entrypoint.sh" ]
