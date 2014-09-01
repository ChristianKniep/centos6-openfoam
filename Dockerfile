FROM centos:centos6
MAINTAINER "Christian Kniep <christian@qnib.org>"

ADD etc/yum.repos.d/qnib.repo /etc/yum.repos.d/qnib.repo
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y openmpi openmpi-devel qt zlib-devel cmake

ENV PATH /usr/lib64/openmpi/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH /usr/lib64/openmpi/lib/
RUN yum install -y yum-utils
RUN yum-config-manager --nogpgcheck --add-repo http://dl.atrpms.net/el6-x86_64/atrpms/stable
RUN yum install -y --nogpgcheck qtwebkit qtwebkit-devel
RUN yum install -y --nogpgcheck CGAL CGAL-devel
RUN yum install -y http://www.openfoam.org/download/rhel/6.5/x86_64/OpenFOAM-scotch-6.0.0-1.x86_64.rpm
RUN yum install -y http://www.openfoam.org/download/rhel/6.5/x86_64/OpenFOAM-ParaView-3.12.0-1.x86_64.rpm
RUN yum install -y  http://www.openfoam.org/download/rhel/6.5/x86_64/OpenFOAM-2.3.0-1.x86_64.rpm 

RUN mkdir -p /chome
RUN useradd -u 2000 -M -d /chome/cluser cluser
RUN echo "cluser:cluser"|chpasswd
RUN yum install -y vim gnuplot
RUN yum install -y openssh-server xauth
RUN ssh-keygen  -q -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" -C "" < /dev/null > /dev/null 2> /dev/null
RUN ssh-keygen  -q -t dsa -f /etc/ssh/ssh_host_dsa_key -N "" -C "" < /dev/null > /dev/null 2> /dev/null
RUN sed -i -e 's/#X11UseLocalhost.*/X11UseLocalhost no/' /etc/ssh/sshd_config

EXPOSE 22
CMD /usr/sbin/sshd -D
