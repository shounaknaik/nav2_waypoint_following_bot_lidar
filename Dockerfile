# Use the official ROS 2 Humble base image
FROM ros:humble

# Install necessary packages
RUN apt-get update && apt-get install -y \
    ros-humble-desktop \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Set up environment
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Create a workspace
RUN mkdir -p /root/ros2_ws/src
WORKDIR /root/ros2_ws

# Build the workspace (optional)
RUN source /opt/ros/humble/setup.bash && colcon build

# Set up entrypoint
COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]