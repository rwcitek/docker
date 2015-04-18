# pdfocr docker build file
# base on edhowland/ubuntu:pdftk
FROM edhowland/ubuntu:pdftk
MAINTAINER Ed Howland
RUN apt-get update
RUN apt-get install -y poppler-utils 
RUN apt-get install -y ocrodjvu  
RUN apt-get install -y ruby ruby-dev
COPY ./src /opt/src
