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
    pixi run -e jazzy colcon test-result --all --verbose

# Format C++ and Python files
format:
    pixi run -e jazzy clang-format -i mote_control/src/*.cc mote_control/include/*.h
    pixi run -e jazzy ruff format mote_control/test

# Check C++ and Python formatting without modifying files
format-check:
    pixi run -e jazzy clang-format --dry-run --Werror mote_control/src/*.cc mote_control/include/*.h
    pixi run -e jazzy ruff format --check mote_control/test

# Lint C++ with clang-tidy and Python with ruff
lint: build
    pixi run -e jazzy clang-tidy -p build/mote_control mote_control/src/*.cc
    pixi run -e jazzy ruff check mote_control/test

ci: format-check lint test

# Install dependencies using the system ROS installation
install-system:
    #!/usr/bin/env bash
    sudo rosdep init || true
    rosdep update --rosdistro jazzy
    rosdep install --from-paths . --ignore-src -y --rosdistro jazzy

# Build ROS packages using the system ROS installation
build-system:
    #!/usr/bin/env bash
    source /opt/ros/jazzy/setup.bash
    colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DPython_FIND_VIRTUALENV=ONLY -DPython3_FIND_VIRTUALENV=ONLY

# Test ROS packages using the system ROS installation
test-system: build-system
    #!/usr/bin/env bash
    source /opt/ros/jazzy/setup.bash
    source install/setup.bash
    colcon test
    colcon test-result --all

# Format C++ and Python files using the system installation
format-system:
    clang-format -i mote_control/src/*.cc mote_control/include/*.h
    ruff format mote_control/test

# Check C++ and Python formatting using the system installation
format-check-system:
    clang-format --dry-run --Werror mote_control/src/*.cc mote_control/include/*.h
    ruff format --check mote_control/test

# Lint C++ with clang-tidy and Python with ruff using the system installation
lint-system: build-system
    clang-tidy -p build/mote_control mote_control/src/*.cc
    ruff check mote_control/test

ci-system: format-check-system lint-system test-system
