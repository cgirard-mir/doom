FROM ubuntu:18.04

ENV UNAME player

ENV USER=root
ENV PASSWORD=pass123
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
COPY doom /dos/doom

RUN apt-get update && \
chmod -R 1777 /dos && \
echo "tzdata tzdata/Areas select America" > ~/tx.txt && \
echo "tzdata tzdata/Zones/America select New_York" >> ~/tx.txt && \
debconf-set-selections ~/tx.txt && \
apt-get install -y tightvncserver ratpoison dosbox novnc websockify pulseaudio

COPY pulse-client.conf /etc/pulse/client.conf

LABEL maintainer="gcameron@mirantis.com"

# Set up the non-root user
RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio

USER $UNAME
ENV HOME /home/$UNAME

# This should all run as the non-root user
RUN  mkdir ~/.vnc/ && \
mkdir ~/.dosbox && \
echo $PASSWORD | vncpasswd -f > ~/.vnc/passwd && \
chmod 0600 ~/.vnc/passwd

RUN echo "set border 0" > ~/.ratpoisonrc  && \
echo "exec dosbox -conf ~/.dosbox/dosbox.conf -fullscreen" >> ~/.ratpoisonrc && \
export DOSCONF=$(dosbox -printconf) && \
cp $DOSCONF ~/.dosbox/dosbox.conf && \
echo MOUNT C: /dos >> ~/.dosbox/dosbox.conf  && \
echo C: >> ~/.dosbox/dosbox.conf  && \
echo CD DOOM >> ~/.dosbox/dosbox.conf  && \
echo IPXNET CONNECT 172.17.0.2 19900 >> ~/.dosbox/dosbox.conf && \
echo DM >> ~/.dosbox/dosbox.conf && \
sed -i 's/ipx=false/ipx=true/' ~/.dosbox/dosbox.conf && \
sed -i 's/usescancodes=true/usescancodes=false/' ~/.dosbox/dosbox.conf && \
openssl req -x509 -nodes -newkey rsa:2048 -keyout ~/novnc.pem -out ~/novnc.pem -days 365 -subj "/C=US/ST=NY/L=NY/O=NY/OU=NY/CN=NY emailAddress=gcameron@mirantis.com"

EXPOSE 213 6081 4713

CMD vncserver && websockify -D --web=/usr/share/novnc/ --cert=~/novnc.pem 6081 localhost:5901 && tail -f /dev/null

