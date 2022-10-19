# octune_jetson
Docker image for the [OCTUNE](https://github.com/mzahana/octune) algorithm with PX4 autopilot, which runs on Nvidia Jetson boards

# Setup
* Create a `src` directory in your Jetson home directory
  ```bash
  cd ~
  mkdir src
  ```
* Clone this repo into `$HOME/src`
  ```bash
  cd $HOME/src
  git clone https://github.com/mzahana/octune_jetson
  ```

* To setup the docker image run the setup script [setup_octune_on_jetson.sh](https://github.com/mzahana/octune_jetson/blob/main/scripts/setup_octune_on_jetson.sh)
  ```bash
  . scripts/setup_octune_on_jetson.sh
  ```
* Reboot your Jetson
* An alias is atuomatically created to easily run the `octune` container. The Docker container is given a default name of `octune`
* You can run the docker container using the alias `octune_container`, or by executing the `scripts/docker_run_octune.sh`
* Create a directory at `$HOME` where the octune yaml file will be placed.
  ```bash
  mkdir -p $HOME/octune_shared_volume
  ```
  This directory is shared with the docker container. So you can exchange data between the docker container and the host system
 * Place the octune yaml file inside the `$HOEME/octune_shared_volume`
* Edit environment variabels that are used inside the Docker contaier in [scripts/octune_env_vars.txt](https://github.com/mzahana/octune_jetson/blob/main/scripts/octune_env_vars.txt)
* Run the `octune` container using the alias `octune_container`
* The octune will run inside the container, and you can start/stop the tuning process using the services explained in [px4_octune_ros](https://github.com/mzahana/px4_octune_ros#test).
* **NOTE** The ROS system runs inside the docker container. So, you need to be inside the container in order to execute ROS commands. You can access the container from a new terminal by running the alias `octune_container` again. Or, you can access the ROS system from your own machine (only ROS melodic) by setting the right `ROS_MASTER_URI` and `ROS_HOSTNAME`
