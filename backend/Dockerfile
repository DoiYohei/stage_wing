FROM ruby:3.0.0-alpine

ARG WORKDIR

ENV RUNTIME_PACKAGES="linux-headers libxml2-dev make gcc libc-dev nodejs tzdata imagemagick mysql-dev mysql-client yarn" \
    DEV_PACKAGES="build-base curl-dev" \
    HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

COPY Gemfile ${HOME}/Gemfile
COPY Gemfile.lock ${HOME}/Gemfile.lock

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache ${RUNTIME_PACKAGES} && \
    apk add --update --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies

COPY . ${HOME}

CMD ["rails", "server", "-b", "0.0.0.0"]
