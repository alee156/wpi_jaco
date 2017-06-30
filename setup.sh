#!/usr/bin/env bash

export ROS_DISTRO=indigo
export ROS_CI_DESKTOP="`lsb_release -cs`"  # e.g. [precise|trusty|...]
export CI_SOURCE_PATH=$(pwd)
export CATKIN_OPTIONS="$CI_SOURCE_PATH/catkin.options"
export ROS_PARALLEL_JOBS='-j8 -l6'
export CATKIN_WS="$HOME/albert_ws"
# export COSTAR_PLAN_DIR="$HOME/albert_ws/src/costar_plan"

sudo apt-get update -qq

echo "======================================================"
echo "PYTHON"
echo "Installing python dependencies:"
echo "Installing basics from apt-get..."
sudo apt-get -y install python-pygame python-dev
echo "Installing smaller libraries from pip..."
sudo -H pip install --no-binary numpy
sudo -H pip install h5py keras keras-rl sympy matplotlib pygame gmr networkx \
  dtw pypr gym PyPNG pybullet numba


echo "======================================================"
echo "ROS"
sudo apt-get install -y python-catkin-pkg python-rosdep python-wstool \
  python-catkin-tools ros-$ROS_DISTRO-catkin ros-$ROS_DISTRO-ros-base
sudo apt-get install -y libfreenect-dev ros-indigo-freenect-launch
echo "--> source ROS setup in /opt/ros/$ROS_DISTRO/setup.bash"
source /opt/ros/$ROS_DISTRO/setup.bash
sudo rosdep init
rosdep update

echo "======================================================"
echo "CATKIN"
echo "Create catkin workspace..."
mkdir -p $CATKIN_WS/src
cd $CATKIN_WS
source /opt/ros/$ROS_DISTRO/setup.bash
catkin init
#cd $CATKIN_WS/src

cd
git clone https://github.com/stonier/sophus.git
cd Sophus
mkdir build
cd build
cmake ..
make
source ../devel/setup.bash

cd $CATKIN_WS/src
git clone https://github.com/alee156/wpi_jaco.git

git clone https://github.com/stonier/ecl_lite.git
git clone https://github.com/stonier/ecl_tools.git
git clone https://github.com/stonier/ecl_core.git

git clone https://github.com/GT-RAIL/rail_manipulation_msgs.git



rosdep install -y --from-paths ./ --ignore-src --rosdistro $ROS_DISTRO
cd $CATKIN_WS/src
catkin make
source $CATKIN_WS/devel/setup.bash

