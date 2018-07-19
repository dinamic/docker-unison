Unison
----

Here's an example of how to sync the content of a certain folder to a given volume:

```
version: '3.6'
services:
  unison:
    image: dinamic/docker-unison
    volumes:
      - sourceCode:/destination
      - /path/to/src:/source:consistent
    privileged: true
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 524288
        hard: 524288
volumes:
  sourceCode:
```
