FROM daocloud.io/centos:6

# 签名
MAINTAINER SuJianchao "sujianchao@gmail.com"

#更新系统，安装Git
RUN yum -y update; yum clean all; 
RUN yum install git -y;

# clone 仓库
WORKDIR  /
RUN git clone https://github.com/sujianchao/amh-4.2.git


#执行amh.sh安装脚本
RUN cd /amh-4.2 && chmod 775 amh-4.2.sh
CMD ./amh-4.2.sh

EXPOSE 80:80 8888:9988