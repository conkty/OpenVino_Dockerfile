# OpenVino_Dockerfile
How to create docker image for OpenVino/OpenCL runtime environment
## Author
weik 'conkty@126.com'

## Supported Platform
* Intel CPU
* Intel GPU
* Intel MYRIAD

## How to Use
### Prepare files
* get the docker file
```
git clone https://github.com/conkty/OpenVino_Dockerfile.git
```

* download openvino and opencl install files, from intel.com and https://github.com/intel/compute-runtime/releases, and then moved into `sdks/` in `OpenVino_Dockerfile` directory.
  
```
cd OpenVino_Dockerfile
mkdir sdks
```

### Build Image
    ```
    # build image, the tag named as you wish
    docker build -t weik/intelvino:v01 .
    ```
DO NOT FORGET THE DOT AT THE TAIL.

The built image is about _1.79GB_ .

### Create container
the parameters `--name`, the second `-v `,  can be changed as you need.

```
# create container
docker create -e DISPLAY=$DISPLAY \                     # can run GUI program
            --device=/dev/dri/card0:/dev/dri/card0 \
            --device=/dev/dri/renderD128:/dev/dri/renderD128 \
            --privileged \
            -v /dev:/dev \
            -it \
            --net=host  \   
            --name wkvino \                                                # the container name, used after
            -v /home/weik/progams:/root/deploy \             # map host directory to the container, espacially where the executable file are in
           weik/intelvino:v01                                            # the image tag given above
```

### Start and Attach
```
docker container start wkvino
docker attach wkvino
```

 In the running container,  the mounted path: `/root/deploy`, your files will be there, enjoy!

You can change the process according to need.

## Tests
