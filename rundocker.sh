
#!/bin/bash

# docker build -t ffanalyse .

docker run --rm -t \
    -v "$(pwd)":/app \
    --name unifitstats \
    --user $(id -u):$(id -g) \
    unifitstats ruby genplots.rb