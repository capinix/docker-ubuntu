FROM ubuntu:22.04

ADD add /root
RUN /root/src/install-ubuntu.sh
EXPOSE 22
CMD [ "/usr/sbin/sshd", "-D" ] 
