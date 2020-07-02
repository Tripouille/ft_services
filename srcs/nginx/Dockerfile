# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aalleman <aalleman@student.42lyon.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/07/02 19:17:36 by aalleman          #+#    #+#              #
#    Updated: 2020/07/02 20:14:58 by aalleman         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

FROM alpine
#ARG DEBIAN_FRONTEND=noninteractive

#RUN apt-get update
#RUN apt-get -y upgrade
RUN apk -U upgrade --no-cache
RUN apk add openrc --no-cache
RUN rc-update add openrc

#Install nginx
#RUN apt-get install -y nginx
RUN apk add nginx
COPY default /etc/nginx/sites-available/default
#COPY srcs/nginx/autoindex.sh .
EXPOSE 80

#Setup ssl
COPY localhost.crt /etc/ssl/certs/
COPY localhost.key /etc/ssl/private/
EXPOSE 443

#COPY and launch run.sh.
RUN rc-update add nginx
COPY run.sh .
CMD ["sh", "run.sh"];