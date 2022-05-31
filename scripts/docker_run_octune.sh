#!/usr/bin/env bash

source $HOME/src/jetson-containers/scripts/l4t_version.sh

DOCKER_REPO="mzahana:octune-r$L4T_VERSION"
CONTAINER_NAME="octune"
USER_VOLUME=""
USER_COMMAND=""

# This will enable running containers with different names
# It will create a local workspace (${HOME}/${CONTAINER_NAME}_shared_volume/) and link it to the image's ~/shared_volume
if [ "$1" != "" ]; then
    CONTAINER_NAME=$1
fi

WORKSPACE_DIR=${HOME}/${CONTAINER_NAME}_shared_volume/
if [ ! -d $WORKSPACE_DIR ]; then
    mkdir -p $WORKSPACE_DIR
fi
echo "Container name:$CONTAINER_NAME WORSPACE DIR:$WORKSPACE_DIR"

####################################################################################
PKG_NAME=octune_jetson
if [ -d "$HOME/$PKG_NAME" ]; then
    . $HOME/$PKG_NAME/scripts/set_octune_env_vars.sh
    echo "Found $HOME/$PKG_NAME/scripts/set_octune_env_vars.sh"
elif [ -d "$HOME/src/$PKG_NAME" ]; then
    . $HOME/src/$PKG_NAME/scripts/set_octune_env_vars.sh
    echo "Found $HOME/src/$PKG_NAME/scripts/set_octune_env_vars.sh"
else
    echo "ERROR Could not find $PKG_NAME package. Exiting" && echo
    exit 1
fi
#source $HOME/.bashrc

echo "Updated OCTUNE environment variables" && echo
sleep 2

##################################################################################

##################################################################################

echo "Starting Container: ${CONTAINER_NAME} with REPO: $DOCKER_REPO"

CMD=" eval $cmd_str &&\
       /bin/bash" 
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${CONTAINER_NAME})" ]; then
        # cleanup
        docker start ${CONTAINER_NAME}
    fi
    if [ -z "$CMD" ]; then
        docker exec -it  ${CONTAINER_NAME} bash
    else
        docker exec -it  ${CONTAINER_NAME} bash -c "$CMD"
    fi
else


# CMD="/bin/bash"
#CMD="source /root/.bashrc && roslaunch mavros px4.launch fcu_url:=/dev/ttyUSB0:921600 gcs_url:=udp://@10.147.20.73"

# cmd_str is exported by the set_ugv_env_vars.sh script
CMD=" eval $cmd_str &&\
        source /root/catkin_ws/devel/setup.bash && \
       roslaunch px4_octune_ros run_on_hardware.launch &&\
       /bin/bash"
# roslaunch psu_delivery_drone_system system.launch &&
# 
# --ipc=host
# --cap-add SYS_PTRACE
# run the container
xhost +si:localuser:root
# xhost +local:root
#xhost +
docker run --runtime nvidia -it --network host -e DISPLAY=$DISPLAY --restart always \
    -v /tmp/.X11-unix/:/tmp/.X11-unix \
    -v /tmp/argus_socket:/tmp/argus_socket \
    -v /dev:/dev \
    -e QT_X11_NO_MITSHM=1 \
    --group-add=dialout \
    --group-add=video \
    --group-add=tty \
    --tty=true \
    --device=/dev/ttyUSB0 \
    --device=/dev/ttyTHS0 \
    -v ${WORKSPACE_DIR}:/root/shared_volume \
    --workdir="/root" \
    --name=${CONTAINER_NAME} \
    --privileged \
    ${DOCKER_REPO} \
    bash -c "${CMD}"
fi
