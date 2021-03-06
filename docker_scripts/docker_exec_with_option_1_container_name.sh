# For example,
# sh docker_exec_with_option_1_container_name.sh kind_goldwasser
# will call
# sudo docker exec -it --user root --workdir / kind_goldwasser /bin/bash
# Here "--user root --workdir /" will put you start at the "/" directory.
sudo docker exec -it --user root --workdir / $1 /bin/bash
