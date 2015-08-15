FROM phusion/baseimage:0.9.16
CMD ["/sbin/my_init"]

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy/snapshots/4.0.0 main" > /etc/apt/sources.list.d/mono-xamarin.list \
	&& apt-get update \
	&& apt-get install -y mono-devel ca-certificates-mono fsharp mono-vbnc nuget \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get -qq update && apt-get -qqy install unzip

ENV DNX_VERSION 1.0.0-beta4
ENV DNX_USER_HOME /opt/dnx

RUN curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_USER_HOME=$DNX_USER_HOME DNX_BRANCH=v$DNX_VERSION sh
RUN bash -c "source $DNX_USER_HOME/dnvm/dnvm.sh \
	&& dnvm install $DNX_VERSION -a default \
	&& dnvm alias default | xargs -i ln -s $DNX_USER_HOME/runtimes/{} $DNX_USER_HOME/runtimes/default"

ENV PATH $PATH:$DNX_USER_HOME/runtimes/default/bin
COPY libuv.so.1 /usr/lib/libuv.so.1

RUN apt-get -qqy install git-core nodejs npm
RUN npm install -g bower
RUN npm install -g grunt-cli
RUN ln -s /usr/bin/nodejs /usr/local/bin/node

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
