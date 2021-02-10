FROM gitpod/workspace-full

USER gitpod

# https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#debianubuntu
RUN sudo apt-get -q update && \
	 sudo apt-get install -yq \
		build-essential ccache ecj fastjar file g++ gawk \
		gettext git java-propose-classpath libelf-dev libncurses5-dev \
		libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
		python3-distutils python3-setuptools rsync subversion swig time \
		xsltproc zlib1g-dev && \
	 sudo rm -rf /var/lib/apt/lists/*

RUN sudo update-ccache-symlinks

ENV PATH="/usr/lib/ccache:$PATH"
