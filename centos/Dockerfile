FROM centos:latest

RUN yum update -y
RUN yum install -y java
RUN mkdir minecraft && curl -o minecraft/minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.10.2/minecraft_server.1.10.2.jar
RUN cd minecraft && java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui
RUN sed -i -e "s/eula=false/eula=true/" /minecraft/eula.txt
