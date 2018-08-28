FROM node:10-slim

# docker build process is treated as locale with in the POSIX.
# It must be defined explicitly in Dockerfile
# https://github.com/docker/docker/issues/2424#issuecomment-27269233
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# apt-get upgrade
RUN set -x \
        && apt-get update -q \
        && apt-get install -qy --no-install-recommends \
             # base toolbelt
             build-essential ca-certificates locales git autotools-dev automake ssh \
             # optional toolbelt
             vim less \
             # require: watchman
             python-dev \
        # Update Locale to en_US.UTF-8
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
        && locale-gen && update-locale LANG=en_US.UTF-8

# Chrome for testing
RUN apt-get install -qy gconf-service libgconf-2-4 libnspr4 libnss3 lsb-release \
      libpango1.0-0 libappindicator1 libcurl3 libasound2 libx11-xcb1 \
      libxss1 libxtst6 fonts-liberation xdg-utils libgtk-3-0 \
      libappindicator3-1 libdbusmenu-gtk3-4 libindicator3-7

RUN curl -O -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb \
    && rm -f google-chrome-stable_current_amd64.deb \
    && sed -i 's|HERE/chrome\"|HERE/chrome\" --disable-setuid-sandbox|g' /opt/google/chrome/google-chrome

# node setup
ENV NPM_CONFIG_LOGLEVEL info

# Install ember-cli and bower
ENV EMBER_CLI_VERSION 3.1.4

RUN set -x \
        && npm install -g bower ember-cli@${EMBER_CLI_VERSION}

# Install watchman
RUN set -x \
        && git clone https://github.com/facebook/watchman.git \
        && cd watchman \
        && git checkout v4.7.0 \
        && ./autogen.sh \
        && ./configure \
        && make \
        && make install

WORKDIR /usr/src/app

# Install npm_modules and bower_components
COPY package.json /usr/src/app
COPY bower.json /usr/src/app

RUN set -x \
        && rm -rf /usr/src/app/bower_components /usr/src/app/node_modules \
        && npm cache clean --force && bower cache clean --allow-root \
	&& npm install && bower install --allow-root

EXPOSE 4200 49153
