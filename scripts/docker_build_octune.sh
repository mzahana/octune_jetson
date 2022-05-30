
set -e
# First clone jetson-containers to build the ROS image
if [ ! -d $HOME/src ]; then
    echo "Creating $HOME/src directory ..."
    mkdir $HOME/src
fi

if [ ! -d "$HOME/src/jetson-containers" ]; then
    cd $HOME/src
    git clone https://github.com/dusty-nv/jetson-containers.git
else
    cd $HOME/src/jetson-containers
    git pull origin master
fi

# Build ROS melodic Docker image
# This will build docker image ros:melodic-ros-base-l4t-r$L4T_VERSION
cd $HOME/src/jetson-containers
./scripts/docker_build_ros.sh --distro melodic

# Get the l4t versoin environment variable L4T_VERSION
cd $HOME/src/jetson-containers
source scripts/l4t_version.sh

docker build --network=host -t mzahana:octune-r$L4T_VERSION \
                -f $HOME/src/octune_jetson/Dockerfile.octune \
            --build-arg BASE_IMAGE=ros:melodic-ros-base-l4t-r$L4T_VERSION \
            --build-arg GIT_TOKEN=$GIT_TOKEN .