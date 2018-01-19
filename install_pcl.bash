#!/bin/bash 
#install softwares in Ubuntu 14.04LTS

echo "update"
sudo apt-get update --force-yes -y
sudo apt-get upgrade --force-yes -y

echo "Installing cmake git "
sudo apt-get install --force-yes -y \
		cmake libtool autoconf automake   \
		git gitg openssh-server g++ libgl1-mesa-dev \
		libglu1-mesa-dev build-essential libglib2.0-dev \
		openjdk-6-jdk python-dev gtk-doc-tools libgtkmm-2.4-dev \
		freeglut3-dev libjpeg-dev libtinyxml-dev libboost-thread-dev \
		libgtk2.0-dev python-gtk2 mesa-common-dev libqwt-dev terminator \
		doxygen

#go into /home/software
#pay attention! eigen/ode/QT5.7/QP/KDL install files should be in directory "home/software" 
cd 
cd software/


#install eigen#
echo "Installing eigen"
rm -rf eigen-eigen-5a0156e40feb
tar -xf eigen-eigen-5a0156e40feb.tar.bz2
cd eigen-eigen-5a0156e40feb
mkdir build 
cd build 
cmake ../. 
make
sudo make install
cd ../../
rm -rf eigen-eigen-5a0156e40feb

#install ode#
echo "Installing ode"
rm -rf ode-0.12
tar -xf ode-0.12.tar.bz2
cd ode-0.12
./autogen.sh
./configure --enable-double-precision
make
sudo make install
sudo cp drawstuff/src/.libs/libdrawstuff.* /usr/local/lib/
sudo cp -rf  include/ode  /usr/local/include/
cd ../
rm -rf ode-0.12

#install QT5.7
echo "Installing QT5.7"
chmod 755 qt-opensource-linux-x64-5.7.0.run
./qt-opensource-linux-x64-5.7.0.run
echo "alias qtt='/home/zb/software/Qt5.7.0/Tools/QtCreator/bin/qtcreator'">>~/.bashrc

#install qurdratic program
echo "Installing QP"
rm -rf qpOASES-3.2.0
unzip  qpOASES-3.2.0.zip
cd qpOASES-3.2.0
mkdir build
cd build
cmake ../.
make
sudo make install
cd ../../
rm -rf qpOASES-3.2.0

#install kinematics and dynamics library
echo "Installing KDL"
cd orocos_kinematics_dynamics/orocos_kdl
rm -r build
mkdir build && cd build && cmake ../. && make
sudo make install
cd ../../../
rm -rf orocos_kinematics_dynamics/orocos_kdl/build

#go back to /home
cd 

#install ros#
echo "Installing ROS"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update --force-yes -y
sudo apt-get install --force-yes -y ros-indigo-desktop-full
sudo rosdep init
rosdep update
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt-get install --force-yes -y  python-rosinstall


#install gazebo#
echo "Installing gazebo"
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install gazebo6
sudo apt-get install ros-indigo-gazebo6-ros-pkgs ros-indigo-gazebo6-ros-control ros-indigo-gazebo6-msgs ros-indigo-gazebo6-ros ros-indigo-gazebo6-plugins

# install gazebo ros pkgs and ros control #
sudo apt-get install --force-yes -y ros-indigo-ros-control ros-indigo-ros-controllers 

#install qtc
echo "Installing qtc"
sudo add-apt-repository ppa:levi-armstrong/qt-libraries-trusty
sudo add-apt-repository ppa:levi-armstrong/ppa 
# sudo add-apt-repository ppa:beineri/opt-qt571-trusty 
sudo apt-get update && sudo apt-get install qt57creator-plugin-ros
echo "alias qt='/opt/qt57/bin/qtcreator-wrapper'" >> ~/.bashrc

#install pcl
sudo add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/pcl
sudo apt-get update
sudo apt-get install libpcl-all
#这个pcl在运行的时候,如果用到#include <pcl/recognition/hv/hv_go.h>时,会显示找不到#include "metslib/mets.hh",可以自行下载pcl-pcl-1.7.1编译,里面的recognition/include/里面有metslib,可以把这个文件夹拷贝到libpcl的文件夹去即可


#install librealsense(for ubuntu14.04 and realsense)
#下载realsense驱动：https://github.com/IntelRealSense/librealsense
cd realsense
#(soft/realsense_driver/librealsense)
sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade
sudo apt-get install --install-recommends linux-generic-lts-xenial xserver-xorg-core-lts-xenial xserver-xorg-lts-xenial xserver-xorg-video-all-lts-xenial xserver-xorg-input-all-lts-xenial libwayland-egl1-mesa-lts-xenial
sudo update-grub && sudo reboot
#这个时候电脑会重启，重启之后我们在选择ubuntu进入的那个界面选择Advanced Options for Ubuntu，选择最新的内核版本，然后进入系统，最后用：uname -r确认版本是否是你所选的。
uname -r 
#确认>= 4.4.0-50 
sudo apt-get install libusb-1.0-0-dev pkg-config
/scripts/install_glfw3.sh #install glfw3 for examples
mkdir build && cd build
cmake ..
cmake ../ -DBUILD_EXAMPLES=true
make && sudo make install
#install Video4Linux
cd ..
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
sudo apt-get install libssl-dev
./scripts/patch-realsense-ubuntu-xenial.sh
sudo dmesg | tail -n 50
#test run ./cpp-capture in librealsense/build/examples
#install ros-indigo-realsense-camera
sudo apt-get install ros-indigo-realsense-camera
# test
roscore
roslaunch realsense_camera sr300_nodelet_rgbd.launch
rosrun rviz rviz

#install super-4pcs(使用1.1.3及后续版本)
cd Super4PCS_1.1.3
#修改CmakeLists,把里面的OPTION (SUPER4PCS_COMPILE_DEMOS "Compile demo applications (including the Super4PCS standalone)" TRUE)的true改为false;
#可能还会出现对pcl的依赖时,pcl的版本不一致的问题,只需要把pcl版本改为本电脑中的版本即可;
#接下来正常编译运行即可
#1.3版本的super4pcs本身就带有与pcl的连接插件



