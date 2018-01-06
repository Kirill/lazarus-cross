# Pull base image.
FROM ubuntu:16.04

# Update.
RUN \
    apt-get update && \
    apt-get -y upgrade

# Upgrade and install all required pkgs
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl git htop man unzip emacs-nox wget && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y clang fuse libfuse-dev libbz2-1.0 libbz2-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libbz2-ocaml libbz2-ocaml-dev cmake libgtk2.0-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libgpmg1-dev fakeroot libncurses5-dev zlib1g-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libxml2-dev autoconf automake libssl-dev

# Add building scripts
ADD config.sh /
ADD pre.build.sh /
ADD build.tools.sh /
ADD compilers.sh /
ADD post.build.sh /

# PreBuild the cross tools
RUN \
    chmod +x /config.sh && \
    chmod +x /pre.build.sh && \
    /pre.build.sh

# Build the cross tools
RUN \
    chmod +x /config.sh && \
    chmod +x /build.tools.sh && \
    /build.tools.sh

# Build the cross compilers
RUN \
    chmod +x /config.sh && \
    chmod +x /compilers.sh && \
    /compilers.sh

# Post build stuff to be done
RUN \
    chmod +x /config.sh && \
    chmod +x /post.build.sh && \
    /post.build.sh

# Define default command.
CMD ["bash"]