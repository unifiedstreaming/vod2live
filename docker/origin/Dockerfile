ARG UPSTREAM_DOCKER_IMAGE=docker.io/unifiedstreaming/unified-origin:1.11.3

FROM $UPSTREAM_DOCKER_IMAGE

# Copy in entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy in demo page
COPY index.html /var/www/unified-origin/index.html
COPY clientaccesspolicy.xml /var/www/unified-origin/clientaccesspolicy.xml
COPY crossdomain.xml /var/www/unified-origin/crossdomain.xml
COPY favicon.ico /var/www/unified-origin/favicon.ico
COPY V2L_SMIL_Playlist_diagram_2020.svg /var/www/unified-origin/V2L_SMIL_Playlist_diagram_2020.svg
COPY static /var/www/unified-origin/static

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["-D", "FOREGROUND"]