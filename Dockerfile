FROM ubuntu:22.04

ADD config/* files/* /root/
RUN /root/install-ubuntu.sh
EXPOSE 22
# RUN mkdir -p /var/run/sshd
CMD [ "/usr/sbin/sshd", "-D" ] 
