#!/bin/bash
set -e

# Source the ROS 2 setup script
source "/opt/ros/$ROS_DISTRO/setup.bash"
exec "$@"
