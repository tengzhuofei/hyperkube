FROM gcr.io/google_containers/hyperkube:v1.15.11
RUN sed -i -e 's!\bmain\b!main contrib!g' /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && apt-get clean && \
    clean-install apt-transport-https gnupg1 curl zfsutils-linux \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && apt-get purge gnupg \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli


RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> \
    /etc/apt/sources.list.d/backports.list \
    && clean-install -t stretch-backports glusterfs-client glusterfs-common  \

    && export DEBID=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"') \
    && export DEBVER=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+') \
    && export DEBARCH=$(dpkg --print-architecture) 

RUN apt-get update -y && apt-get install -y wget && wget -O - https://download.gluster.org/pub/gluster/glusterfs/LATEST/rsa.pub | apt-key add - \
    && wget -O - https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub | apt-key add - 
RUN echo deb https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/${DEBID}/${DEBARCH}/apt ${DEBVER} main > /etc/apt/sources.list.d/\ gluster.list && apt-get install -y glusterfs-client