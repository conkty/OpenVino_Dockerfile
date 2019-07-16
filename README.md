# OpenVino_Dockerfile
How to create docker image for OpenVino/OpenCL runtime environment
## Author
weik 'conkty@126.com'

## Supported Platform
* Intel CPU
* Intel GPU
* Intel MYRIAD

## How to Use
### Build the Docker Image
```
git clone https://github.com/conkty/OpenVino_Dockerfile.git
cd OpenVino_Dockerfile

mkdir sdks

# firstly, download openvino and opencl install files into sdks/

# then build, the tag named as you wish
docker build -t weik/intelvino:v01 .
```
DON'T FORGET THE DOT AT THE TAIL.

### Create container and run

```
# wait, and then create container
docker create -e DISPLAY=$DISPLAY \                     # can run GUI program
            --device=/dev/dri/card0:/dev/dri/card0 \
            --device=/dev/dri/renderD128:/dev/dri/renderD128 \
            --privileged \
            -v /dev:/dev \
            -it \
            --net=host  \   
            --name wkvino \                                                 # the container name, used after
            -v /home/weik/progams:/root/deploy \               # map host directory to the container, espacially where the executable file are in
           weik/intelvino:v01                                               # the image tag given above
# then start and attach

docker container start wkvino
docker attach wkvino


```
then in the running container, into the mounted path: `/root/deploy`, your files will be there, enjoy!

You can change the process according to need.

## Tests
