FROM gitpod/workspace-full:latest

USER gitpod

# https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem#debianubuntumint
RUN sudo apt-get -q update && \
		sudo apt-get install -yq \
			build-essential ccache clang flex bison g++ gawk \
			gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev \
			python3-distutils rsync unzip zlib1g-dev file wget zstd && \
	 sudo rm -rf /var/lib/apt/lists/*

RUN sudo update-ccache-symlinks

ENV PATH="/usr/lib/ccache:$PATH"
