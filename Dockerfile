FROM alpine:3.6 as builder

MAINTAINER Nikola Petkanski <nikola@petkanski.com

RUN apk add --update --virtual .build-dependencies build-base curl && \
    apk add inotify-tools ocaml

ARG UNISON_VERSION=2.51.2
RUN curl -L https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz | tar zxv -C /tmp && \
    cd /tmp/unison-${UNISON_VERSION} && \
    sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c && \
    make UISTYLE=text NATIVE=true STATIC=true && \
    cp src/unison src/unison-fsmonitor /usr/local/bin

COPY unison.conf /.unison/default.prf
RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf

FROM scratch

COPY --from=builder /usr/local/bin/unison /unison
COPY --from=builder /usr/local/bin/unison-fsmonitor /unison-fsmonitor
COPY --from=builder /etc/sysctl.conf /etc/sysctl.conf

COPY unison.conf /.unison/default.prf

ENTRYPOINT ["/unison", "default"]
