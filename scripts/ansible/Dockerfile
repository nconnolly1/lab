FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y gnupg2 python3-pip sshpass git openssh-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible==2.9.6 && \
    pip install pywinrm==0.4.2 && \
    rm -rf /root/.cache/pip

CMD [ "ansible-playbook", "--version" ]
