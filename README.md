# Waypoint Follower Robot

The following repository tries to build a robot from scratch, put a lidar on it and then navigate through 4 waypoints.
It also tries to dockerize the entire application so that it can work on any computer.

This repository was made by following this tutorial - (https://automaticaddison.com/the-ultimate-guide-to-the-ros-2-navigation-stack).

## URDF and SDF Files
In the `models` folder, there is a URDF file. This URDF file describes the entire robot structure with joint and sensor information.
This robot, named basic_mobile_bot, features a main chassis with two rear drive wheels and a front caster wheel for mobility. It includes a LIDAR sensor, mounted on a fixed base. It is said that URDFs don’t always work that well with Gazebo. It is recommended to use an SDF file for Gazebo stuff and a URDF file for ROS stuff. Thus there is also a SDF file present.

## Creating the world 
The map of the world is given in `maps`. The actual world is in the `worlds` folder. It is imperative that the `robot_model_type` in `nav2_params.yam` is set to `"nav2_amcl::DifferentialMotionModel"`. Otherwise RViz does not import the map correctly. Also it is imperative to allow publishment of `odom` by keeping `<publish_odom_tf>true</publish_odom_tf>`. This allows for the system to callculate transformations between `odom` and other frames in the robot.  

The `launch` folder has the launch file. It loads all the appropriate data files and then launches nodes like `robot_state_publisher`,`'rviz2` etc.
We are not using the `robot_localisation` package and the only sensor on board is the lidar and thus the robot's localisation wouldn't be that good.   

I have set the initial_pose of the robot already in the `nav2_params.yaml`. 

## Waypoint following node
There were 4 waypoints given to the environment once it loaded. The script for this is given in `src/waypoint_follower.py`.
This script is adopted from [Samsung Research](https://github.com/ros-navigation/navigation2/tree/main/nav2_simple_commander/nav2_simple_commander). This script accepts 4 poses and continually sends signals to the robot to go to the required waypoint. It also has a feedback where it stops when it has reached a waypoint. 

## Running the Code

### Prerequisites
- Ubuntu 22
- ROS 2 Humble
- Nav2 packages

### Instructions

0. Install Nav2
	```
	sudo apt install ros-humble-navigation2
	sudo apt install ros-humble-nav2-bringup
	```

1. **Build the package**
	```
	colcon build
	source install/setup.bash
    ```

2. **Set Environment Variables:**
   - Add the following lines to your `.bashrc` file:
     ```
     source /opt/ros/humble/setup.bash  
     export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/shounak/dev_ws/src/basic_mobile_robot/models/
     ```
     Into the terminal,

     `source install/setup.bash`

3. **Launch Nav2 and the Entire Simulations:**
     ```
     ros2 launch basic_mobile_robot basic_mobile_bot.launch.py
     ```
     This will load the world along with all the nodes like nav2.

4. **Launch the WayPoint Follower Node:**
   - Open a new terminal and run:
     ```
     source install/setup.bash
     ros2 run basic_mobile_robot waypoint_follower.py
     ```
   - The robot should follow to the waypoints and then stop after the 4 waypoints. 

### Visualization 

Here's a video demonstrating the robot following 4 waypoints:

https://github.com/user-attachments/assets/f597a7b3-1816-4314-8a41-059708df3c70

<!-- <p align = "center">
<img src = "void_submission.mp4" width = 400, height = 300> 
</p>  -->

<p align="center">
    <video width="600" height="300" controls>
        <source src="void_submission.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
</p>

## Docker 

While I am not very well versed with Docker, I have tried my very best to dockerize the solution along with `nav2`.  I would love to tackle this problem further and learn about Docker while at Void Robotics.
Firstly, I tried pulling a docker, running it and visualizing the interface in `noVNC`. The containers that I used were official containers.
   - Open a new terminal and run:
     ```
      sudo docker pull tiryoh/ros2-desktop-vnc:humble
      sudo docker run -i -p 6080:80 -v /void_robot --name void_robot tiryoh/ros2-desktop-vnc:humble
     ```
Then I was succesfull in launching a Gazebo window and launching a turtlebot in Docker
<p align = "center">
<img src = "images/novnc.png" width = 600, height = 300> 
</p>  

When I copied the source file into this docker file, I could build my package but `nav2` was not found. I tried docker file from [husarion](https://github.com/husarion/navigation2-docker/blob/main/Dockerfile). I tried building the docker file but the image did not start even after 5 minutes. The same was the case when I pulled the docker file. 

<p align = "center">
<img src = "images/nav2_nf.png" width = 600, height = 300> 
</p>   

I also tried to follow the official link - https://docs.nav2.org/development_guides/build_docs/index.html#install. Here the dockers only build for `rolling` tag and not for `humble` tag. The `rolling` tag docker failed to load as well. 

<p align = "center">
<img src = "images/docker_fail.png" width = 600, height = 300> 
</p>   


I also tried to write my own Dockerfile but the `nav2` problem still remains. I would love to tackle this problem further and learn about Docker while at Void Robotics!