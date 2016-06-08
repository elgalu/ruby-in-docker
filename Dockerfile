######################################################
# Latest Ruby in latest Ubuntu inside a docker image #
######################################################
#== Ubuntu xenial is 16.04, i.e. FROM ubuntu:16.04
# search for more at https://registry.hub.docker.com/_/ubuntu/tags/manage/
FROM ubuntu:xenial-20160525
ENV UBUNTU_FLAVOR="xenial" \
    UBUNTU_DATE="20160525"

#== Ubuntu flavors - common
RUN  echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR} main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-updates main universe\n" >> /etc/apt/sources.list

MAINTAINER Leo Gallucci <elgalu3@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

#========================
# Miscellaneous packages
#========================
# netcat-openbsd - nc — arbitrary TCP and UDP connections and listens
# net-tools - arp, hostname, ifconfig, netstat, route, plipconfig, iptunnel
# iputils-ping - ping, ping6 - send ICMP ECHO_REQUEST to network hosts
# apt-utils - commandline utilities related to package management with APT
# wget - The non-interactive network downloader
# curl - transfer a URL
# bc - An arbitrary precision calculator language
# pwgen: generates random, meaningless but pronounceable passwords
# ts from moreutils will prepend a timestamp to every line of input you give it
# grc is a terminal colorizer that works nice with tail https://github.com/garabik/grc
RUN apt-get update -qqy \
  && apt-get -qqy install \
    apt-utils \
    sudo \
    net-tools \
    telnet \
    jq \
    netcat-openbsd \
    iputils-ping \
    unzip \
    wget \
    curl \
    pwgen \
    bc \
    grc \
    moreutils \
    tree \
    openssh-client \
  && rm -rf /var/lib/apt/lists/*

#==============================
# Source code control packages
#==============================
# bzr - Bazaar is a distributed version control system
RUN apt-get update -qqy \
  && apt-get -qqy install \
    mercurial \
    subversion \
    bzr \
    git-core \
  && rm -rf /var/lib/apt/lists/*

#====================================
# From docker-library/buildpack-deps
#====================================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    autoconf \
    automake \
    bzip2 \
    file \
    g++ \
    gcc \
    imagemagick \
    libbz2-dev \
    libc6-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libevent-dev \
    libffi-dev \
    libgeoip-dev \
    libglib2.0-dev \
    libjpeg-dev \
    liblzma-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmysqlclient-dev \
    libncurses-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    patch \
    xz-utils \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

#==============================
# Locale and encoding settings
#==============================
# TODO: Allow to change instance language OS and Browser level
#  see if this helps: https://github.com/rogaha/docker-desktop/blob/68d7ca9df47b98f3ba58184c951e49098024dc24/Dockerfile#L57
ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}
RUN locale-gen ${LANGUAGE} \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get update -qqy \
  && apt-get -qqy install \
    language-pack-en \
  && rm -rf /var/lib/apt/lists/*

#===================
# Timezone settings
#===================
# Full list at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#  e.g. "US/Pacific" for Los Angeles, California, USA
# e.g. ENV TZ "US/Pacific"
ENV TZ "Europe/Berlin"
# Apply TimeZone
RUN echo "Setting time zone to '${TZ}'" \
  && echo ${TZ} > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

#========================================
# Add normal user with passwordless sudo
#========================================
ENV NORMAL_USER application
ENV NORMAL_GROUP ${NORMAL_USER}
ENV NORMAL_USER_UID 998
ENV NORMAL_USER_GID 997
RUN groupadd -g ${NORMAL_USER_GID} ${NORMAL_GROUP} \
  && useradd ${NORMAL_USER} --uid ${NORMAL_USER_UID} \
         --shell /bin/bash  --gid ${NORMAL_USER_GID} \
         --create-home \
  && usermod -a -G sudo ${NORMAL_USER} \
  && gpasswd -a ${NORMAL_USER} video \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers
ENV NORMAL_USER_HOME /home/${NORMAL_USER}

#===========
# Ruby time
#===========
ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.1
ENV RUBY_DOWNLOAD_SHA256 b87c738cb2032bf4920fef8e3864dc5cf8eae9d89d8d523ce0236945c5797dcd
ENV RUBYGEMS_VERSION 2.6.4

# skip installing gem documentation
RUN echo 'install: --no-document\nupdate: --no-document' >> "$HOME/.gemrc"

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update -qqy \
  && apt-get install -y bison libgdbm-dev ruby \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/src/ruby \
  && curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
  && echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
  && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
  && rm ruby.tar.gz \
  && cd /usr/src/ruby \
  && autoconf \
  && ./configure --disable-install-doc \
  && make -j"$(nproc)" \
  && make install \
  && apt-get purge -y --auto-remove bison libgdbm-dev ruby \
  && gem update --system $RUBYGEMS_VERSION \
  && rm -r /usr/src/ruby \
  && rm -rf /var/lib/apt/lists/*

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

ENV BUNDLER_VERSION 1.11.2

RUN gem install bundler --version "$BUNDLER_VERSION" \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin" \
  && bundle config --global silence_root_warning true

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

#=====================
# Use Normal User now
#=====================
USER ${NORMAL_USER}

#======
# Envs
#======
ENV \
  # User and home
  USER="${NORMAL_USER}" \
  HOME="${NORMAL_USER_HOME}" \
  # Vnc password file
  BIN_UTILS="/usr/bin" \
  # Docker for Mac beta - containers do not start #227
  no_proxy=localhost \
  # can be: debug, warn, trace, info
  LOG_LEVEL=info \
  # when DISABLE_ROLLBACK=true it will:
  #  - output logs
  #  - exec bash to permit troubleshooting
  DISABLE_ROLLBACK=false \
  LOGFILE_MAXBYTES=10MB \
  LOGFILE_BACKUPS=5 \
  # Amount of lines to display when startup errors
  TAIL_LOG_LINES="15" \
  # Fix small tiny 64mb shm issue
  #===============================
  # Restore
  DEBIAN_FRONTEND="" \
  DEBCONF_NONINTERACTIVE_SEEN=""

#================
# Binary scripts
#================
ADD bin/* ${BIN_UTILS}/
ADD host-scripts/* /host-scripts/
ADD test/* /test/
ADD test/run_test.sh /usr/bin/run_test

#==========
# Fix dirs
#==========
# Create and fix directories perms
RUN  sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} ${NORMAL_USER_HOME} \
  && sudo chown -R ${NORMAL_USER}:${NORMAL_GROUP} /test \
  && echo ""

CMD [ "irb" ]
