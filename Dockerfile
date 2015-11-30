FROM daocloud.io/centos:6

# 签名
MAINTAINER SuJianchao "sujianchao@gmail.com"

#更新系统，安装git、tar、unzip
RUN yum -y update; yum clean all; 
RUN yum install git tar unzip -y;

# 安装openssh-server和sudo软件包，并且将sshd的UsePAM参数设置成no
RUN yum install -y openssh-server sudo
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
 
# 添加测试用户admin，密码admin，并且将此用户添加到sudoers里
#RUN useradd admin
#RUN echo "admin:admin" | chpasswd
#RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers
# 设置root密码
RUN echo "root:sujianchao" | chpasswd

# 下面这两句比较特殊，在centos6上必须要有，否则创建出来的容器sshd不能登录
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key

# clone 仓库
WORKDIR  /
RUN git clone https://github.com/sujianchao/amh-4.2.git

#执行amh.sh安装脚本
RUN cd /amh-4.2 && chmod 775 amh-4.2.sh && sh amh-4.2.sh

#启动amh
#RUN /etc/init.d/amh-start && amh host list

# 启动sshd服务并且暴露相关端口
RUN mkdir /var/run/sshd
EXPOSE 21 22 80 8888

VOLUME /home
RUN chown -R www:www /home/www
RUN chown -R mysql:mysql /home/mysql

CMD ["/usr/sbin/sshd", "-D"]
