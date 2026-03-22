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
    pixi run -e jazzy colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DPython_FIND_VIRTUALENV=ONLY -DPython3_FIND_VIRTUALENV=ONLY

test: build
    pixi run -e jazzy colcon test
    pixi run -e jazzy colcon test-result --all

# Format C++ files using clang-format
format:
    pixi run -e jazzy clang-format -i mote_control/src/*.cc mote_control/include/*.h

# Check C++ formatting without modifying files
format-check:
    pixi run -e jazzy clang-format --dry-run --Werror mote_control/src/*.cc mote_control/include/*.h

# Lint packages using ament tools
lint:
    pixi run -e jazzy ament_cpplint mote_control/src mote_control/include
    pixi run -e jazzy ament_cppcheck mote_control/src mote_control/include
    pixi run -e jazzy ament_flake8 mote_control/test
    pixi run -e jazzy ament_pep257 mote_control/test

ci: format-check lint test

# Build ROS packages using the system ROS installation
build-apt:
    #!/usr/bin/env bash
    source /opt/ros/jazzy/setup.bash
    colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DPython_FIND_VIRTUALENV=ONLY -DPython3_FIND_VIRTUALENV=ONLY

# Test ROS packages using the system ROS installation
test-apt: build-apt
    #!/usr/bin/env bash
    source /opt/ros/jazzy/setup.bash
    colcon test
    colcon test-result --all

# Format C++ files using the system clang-format installation
format-apt:
    clang-format -i mote_control/src/*.cc mote_control/include/*.h

# Check C++ formatting using the system clang-format installation
format-check-apt:
    clang-format --dry-run --Werror mote_control/src/*.cc mote_control/include/*.h

# Lint packages using the system ROS installation
lint-apt:
    #!/usr/bin/env bash
    source /opt/ros/jazzy/setup.bash
    ament_cpplint mote_control/src mote_control/include
    ament_cppcheck mote_control/src mote_control/include
    ament_flake8 mote_control/test
    ament_pep257 mote_control/test

ci-apt: format-check-apt lint-apt test-apt
