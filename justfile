[default]
_default:
    just --list

# Install the ROS environment
install:
    pixi install

# Activate ROS in the current shell
ros_shell:
    pixi shell -e kilted

