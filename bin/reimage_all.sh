#!/usr/bin/env bash

for id in 614aa1e0 054f967f 6d646ef9 6910acfb; do
    /opt/gateway/venv/bin/gateway imaging create ${id}
done
/opt/gateway/venv/bin/gateway imaging get

for hostname in k8s100 k8s101 k8s102 k8s103; do
    ssh root@${hostname} reboot
done
