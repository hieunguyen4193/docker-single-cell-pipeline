#!/bin/bash
port=$1;
name=$2;
docker_name=$3;

sudo docker run -it \
    -v /home/hieunguyen:/home/hieunguyen \
    -v /media:/media -p ${port}:8787 -p 4141:4141 \
    -e PASSWORD=genov4 --name ${name} \
    ${docker_name}:latest

# bash run_docker_container_deploy_CRC1382.sh 8181 rstudio1 tronghieunguyen/single_cell_pipeline 

# bash run_docker_container_deploy_CRC1382.sh 8282 shinyapps_interactiveumap tronghieunguyen/single_cell_pipeline