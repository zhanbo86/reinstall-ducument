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


