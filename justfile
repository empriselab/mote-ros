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
    pixi run -e jazzy build

test: build
    pixi run -e jazzy test
