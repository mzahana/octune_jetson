# octune_jetson
Docker image for the [OCTUNE](https://github.com/mzahana/octune) algorithm with PX4 autopilot, which runs on Nvidia Jetson boards
# Citation
If you use this work in your research, please cite the following reference.
```

@Article{s22239240,
AUTHOR = {Abdelkader, Mohamed and Mabrok, Mohamed and Koubaa, Anis},
TITLE = {OCTUNE: Optimal Control Tuning Using Real-Time Data with Algorithm and Experimental Results},
JOURNAL = {Sensors},
VOLUME = {22},
YEAR = {2022},
NUMBER = {23},
ARTICLE-NUMBER = {9240},
URL = {https://www.mdpi.com/1424-8220/22/23/9240},
ISSN = {1424-8220},
ABSTRACT = {Autonomous robots require control tuning to optimize their performance, such as optimal trajectory tracking. Controllers, such as the Proportional&ndash;Integral&ndash;Derivative (PID) controller, which are commonly used in robots, are usually tuned by a cumbersome manual process or offline data-driven methods. Both approaches must be repeated if the system configuration changes or becomes exposed to new environmental conditions. In this work, we propose a novel algorithm that can perform online optimal control tuning (OCTUNE) of a discrete linear time-invariant (LTI) controller in a classical feedback system without the knowledge of the plant dynamics. The OCTUNE algorithm uses the backpropagation optimization technique to optimize the controller parameters. Furthermore, convergence guarantees are derived using the Lyapunov stability theory to ensure stable iterative tuning using real-time data. We validate the algorithm in realistic simulations of a quadcopter model with PID controllers using the known Gazebo simulator and a real quadcopter platform. Simulations and actual experiment results show that OCTUNE can be effectively used to automatically tune the UAV PID controllers in real-time, with guaranteed convergence. Finally, we provide an open-source implementation of the OCTUNE algorithm, which can be adapted for different applications.},
DOI = {10.3390/s22239240}
}
```

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
