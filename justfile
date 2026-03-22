[default]
_default:
    just --list

# Install the ROS environment
install:
    pixi install

# Activate ROS in the current shell
shell:
    pixi shell -e jazzy

build:
    pixi run colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DPython_FIND_VIRTUALENV=ONLY -DPython3_FIND_VIRTUALENV=ONLY

test: build
    pixi run colcon test
    pixi run colcon test-result --all
