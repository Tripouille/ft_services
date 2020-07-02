# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aalleman <aalleman@student.42lyon.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/07/02 19:17:36 by aalleman          #+#    #+#              #
#    Updated: 2020/07/02 22:32:16 by aalleman         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

FROM alpine

RUN apk -U upgrade --no-cache

#Add index
COPY index.html /var/www/html/index.html

#Install nginx
RUN mkdir -p /run/nginx
RUN apk add nginx
#COPY default /etc/nginx/sites-available/default
COPY default /etc/nginx/conf.d/default.conf
EXPOSE 80

#Setup ssl
COPY localhost.crt /etc/ssl/certs/
COPY localhost.key /etc/ssl/private/
EXPOSE 443

#COPY and launch run.sh.
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]