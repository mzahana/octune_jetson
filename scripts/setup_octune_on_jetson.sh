!/usr/bin/env bash

# configure dialout group

# Add docker group and user to it
echo " " && echo "Docker configuration ..." && echo " "
sudo groupadd docker
sudo gpasswd -a $(whoami) docker

# Enable docker automatically after system boot
# Reference: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot
 sudo systemctl enable docker.service
 sudo systemctl enable containerd.service

# Adjust serial port permissions
echo " " && echo "Serial ports configuration (ttyTHS1) ..." && echo " "
sudo usermod -aG dialout $(whoami)
sudo usermod -aG tty $(whoami)

echo " " && echo "Adding udev rules for /dev/ttyTHS* ..." && echo " " && sleep 1
echo 'KERNEL=="ttyTHS*", MODE="0666"' | sudo tee /etc/udev/rules.d/55-tegraserial.rules
# nvgetty needs to be disabled in order to set ppermanent permissions for ttyTHS1 on jetson nano
# see (https://forums.developer.nvidia.com/t/read-write-permission-ttyths1/81623/5)

echo " " && echo "Disabling nvgetty ..." && echo " " && sleep 1
sudo systemctl stop nvgetty
sudo systemctl disable nvgetty
sudo udevadm trigger

# GIT_TOKEN must be exported (e.g. in .bashrc)
if [ -z "$GIT_TOKEN" ]; then
	echo && echo "ERROR: GIT_TOKEN of the Github pkgs is not exported. Contact your Github admin to obtain it." && echo
	exit 10
fi
PKG_NAME=octune_jetson
cd $HOME/src/$PKG_NAME/
echo " " && echo "Building $HOME/src/$PKG_NAME/Dockerfile.octune ..." && echo " " && sleep 1
./scripts/docker_build_octune.sh

echo " " && echo "Adding alias to .bashrc script ..." && echo " "
grep -xF "alias octune_container='source \$HOME/src/$PKG_NAME/scripts/docker_run_octune.sh'" ${HOME}/.bashrc || echo "alias octune_container='source \$HOME/src/$PKG_NAME/scripts/docker_run_octune.sh'" >> ${HOME}/.bashrc

echo " " && echo "#------------- You can run the OCTUNE container from the terminal by executing octune_container -------------#" && echo " "


cd $HOME

echo "#------------- Please reboot your Jetson for some changes to take effect -------------#" && echo "" && echo " "