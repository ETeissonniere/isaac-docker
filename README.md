# Isaac Lab docker images
Simple container to run Isaac Lab in docker. Note that successfully using this container requires 
the use of Docker and the Nvidia Container Toolkit with a valid Cuda &drivers installation.
Installing these is out of scope of this repository but can be easily googled. For convenience,
you may wanna check out the below links (while these are from the Arch Wiki they should work for 
if not any distributions):
1. [Docker on Arch Wiki](https://wiki.archlinux.org/title/Docker)
2. [Docker + Nvidia on Arch Wiki](https://wiki.archlinux.org/title/Docker#Run_GPU_accelerated_Docker_containers_with_NVIDIA_GPUs)

> Due to the dependency on Isaac Sim docker image, by running this container you are implicitly agreeing 
> to the [NVIDIA Omniverse EULA](https://docs.omniverse.nvidia.com/install-guide/latest/common/NVIDIA_Omniverse_License_Agreement.html).
> If you do not agree to the EULA, do not run this container.


## Setup and building

Because this container depend on the Isaac Sim base image, we cannot offer it for download and you will
need to build them yourself. 

In order to be able to pull the Isaac Sim image, you will need to login to NVCR with your [NGC API Key](https://docs.nvidia.com/ngc/gpu-cloud/ngc-user-guide/index.html#generating-api-key).

Once done, you may build the container via `docker build -t nvidia/isaac-lab -f Dockerfile .`.

### Advanced config

While we recommend using the default configuration, you may use the below build arguments to personalize
your installation:
- `V_ISAACSIM` version of the isaac sim container to pull from Nvidia
- `V_ISAACLAB` github version of isaac lab to setup

Please note that changing these values might lead to a faulty installation as both Isaac Sim and Isaac Lab 
are quite picky to install.

### Shell installation

For convenience, we recommend setting the below function in your shell which will ensure you maximize the
performances and use of the container. Instructions from this point on will assume the function is defined
in your `.zshrc`, `.bashrc` or similar.
```sh
function isaaclab() {
  docker run -v $(pwd):/work \
    --gpus all \
    --network=host \
    -it nvidia/isaac-lab "$@"
}
```

Note that we use `--network=host` so that whatever port Isaac opens is made accessible. Fine tune as necessary.


## Running a sample project

Simply run `isaaclab -p <path to project python file>`, for example `isaaclab -p ./source/standalone/demos/quadrupeds.py`.

By default this will run the code in "headless" mode meaning no rendering nor livestreaming which allows
for better performances.

### Accessing the WebRTC livestream

Livestreaming can be turned on by passing `--livestream 2` to `isaaclab` which will then
be forwarded to the container. Possible values for `--livestream` are:
- `0` (default) which runs with no livestreaming
- `1` which uses Omniverse native livestreaming and requires a local omniverse installation
- `2` which uses WebRTC mode and works in the browser

One may access the WebRTC client via the following URL (insert your server IP address): `http://<IP>:8211/streaming/webrtc-client/?server=<IP>`.
