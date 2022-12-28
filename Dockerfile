FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y gnupg2 wget \
&& apt-get install -y software-properties-common dirmngr \
&& wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor -o /usr/share/keyrings/r-project.gpg \
&& echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | tee -a /etc/apt/sources.list.d/r-project.list \
&& apt-get update \
&& apt-get install r-base -y \
&& apt-get clean all && \
apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install gdebi-core -y \
&& wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb \
&& gdebi -n ./libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb \
&& wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-2022.12.0-354-amd64.deb \
&& apt-get autoremove -y \
&& apt-get update \
&& gdebi -n ./rstudio-server-2022.12.0-354-amd64.deb \
&& apt-get clean all && \
apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y git \
&& apt-get install -y libreoffice \
&& apt-get install -y texlive-full texlive-xetex \
&& echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
&& apt-get install -y ttf-mscorefonts-installer \
&& apt-get clean all && \
apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN Rscript -e "install.packages(c('tidyverse', 'sjlabelled', 'haven', 'magrittr', 'dplyr', 'psych', 'knitr', 'ggthemes'), repos='https://cran.wu.ac.at/');"

ENTRYPOINT usr/lib/rstudio-server/bin/rserver --www-port=8888  --server-daemonize=0 && /bin/bash 
#https://forums.docker.com/t/how-to-run-bash-command-after-startup/21631
