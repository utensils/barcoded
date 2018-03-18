# Barcoded
#
# VERSION       1.2.0

FROM ruby:2-alpine
MAINTAINER Sean Callan, James Brink

# Create barcoded group and user.
RUN addgroup -S barcoded && adduser -S -h /app -s /bin/sh -G barcoded barcoded

# Copy docker assets and application files.
COPY ./ /app

# Set setup docker-assets and set permissions.
RUN cp -rv /app/docker-assets/* / \
    && rm -rf /app/docker-assets \
    && chown -R barcoded:barcoded /app \
    && chown -R barcoded:barcoded /usr/local/etc/barcoded

# Install application and build dependencies
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.5/main' >> /etc/apk/repositories \
    && apk --no-cache --update add --virtual build-deps build-base linux-headers imagemagick-dev=6.9.6.8-r1 \
    && apk --no-cache --update add --virtual app-deps imagemagick=6.9.6.8-r1 \
    && su barcoded -c "cd /app && /usr/bin/env && sh -c bundle install --with=production --no-cache" \
    && apk del build-deps

# Set container to user barcoded user.
USER barcoded

# Set working directory to barcoded app.
WORKDIR /app

# Set environment variable defaults.
ENV RACK_ENV=production \
    RACK_CORS=disabled \
    UNICORN_WORKERS=1 \
    UNICORN_TIMEOUT=30 \
    UNICORN_BACKLOG=64

# Expose unicorn port.
EXPOSE 8080

# Execute entrypoint configuring and executing unicorn.
CMD ["/usr/local/bin/entrypoint.sh"]
