#!/bin/bash

# Get packages required for OpenCV
sudo apt-get -y install libjpeg-dev libtiff5-dev libjasper-dev libpng-dev
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get -y install libxvidcore-dev libx264-dev
sudo apt-get -y install qt4-dev-tools
sudo apt-get -y install libatlas-base-dev

# Ask user for OpenCV version to install
read -p "Do you want to install the current version of OpenCV (option 1) or version 3.4.11.41 (option 2)? Enter 1 or 2: " opencv_option
if [ "$opencv_option" -eq 1 ]; then
    pip3 install -vvv --no-cache-dir opencv-python
elif [ "$opencv_option" -eq 2 ]; then
    pip3 install -vvv --no-cache-dir opencv-python==3.4.11.41
else
    echo "Invalid option for OpenCV version"
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "Failed to install opencv-python"
    exit 1
fi

# Get packages required for TensorFlow
ARCH=$(uname -m)
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1-2)

ARCH_SUFFIX=""
if [ "$ARCH" = "aarch64" ]; then
    echo "64-bit detected"
    ARCH_SUFFIX="aarch64"
elif [ "$ARCH" = "armv7l" ]; then
    echo "32-bit detected"
    ARCH_SUFFIX="armv7l"
else
    echo "Unknown architecture"
    exit 1
fi

echo "Do you want to install TensorFlow from pip (option 1) or from URL (option 2)?"
read -p "Enter 1 or 2: " tf_option

if [ "$tf_option" -eq 1 ]; then
    if [ "$ARCH_SUFFIX" = "aarch64" ]; then
        pip3 install -vvv --no-cache-dir tensorflow-aarch64
        if [ $? -ne 0 ]; then
            echo "Failed to install tensorflow-aarch64"
            exit 1
        fi
    elif [ "$ARCH_SUFFIX" = "armv7l" ]; then
        pip3 install -vvv --no-cache-dir tensorflow
        if [ $? -ne 0 ]; then
            echo "Failed to install tensorflow"
            exit 1
        fi
    fi
elif [ "$tf_option" -eq 2 ]; then
    URL="https://github.com/google-coral/pycoral/releases/download/v2.0.0/tflite_runtime-2.5.0.post1-cp${PYTHON_VERSION//.}-cp${PYTHON_VERSION//.}m-linux_$ARCH_SUFFIX.whl"
    if [ "$PYTHON_VERSION" = "3.9" ] || [ "$PYTHON_VERSION" = "3.8" ]; then
        URL=${URL/m/}
    fi
    pip3 install -vvv --no-cache-dir $URL
    if [ $? -ne 0 ]; then
        echo "Failed to install tflite_runtime from $URL"
        exit 1
    fi
else
    echo "Invalid option for TensorFlow installation"
    exit 1
fi
