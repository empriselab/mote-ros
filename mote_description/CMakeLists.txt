cmake_minimum_required(VERSION 3.10)
project(mote_description)

find_package(ament_cmake REQUIRED)

install(
  DIRECTORY mote/urdf mote/rviz
  DESTINATION share/${PROJECT_NAME}/mote
)

ament_package()
