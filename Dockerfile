FROM node:14-buster as build

RUN apt-get update \
	&& apt-get install -y bash git build-essential

ADD . /opt/data-transport-layer
RUN cd /opt/data-transport-layer && yarn install && yarn build

FROM node:14-buster
RUN apt-get update \
	&& apt-get install -y bash curl jq

COPY --from=build /opt/data-transport-layer /opt/data-transport-layer

COPY wait-for-l1.sh /opt/wait-for-l1.sh

RUN chmod +x /opt/wait-for-l1.sh

WORKDIR /opt/data-transport-layer

ENTRYPOINT ["/opt/wait-for-l1.sh", "yarn", "start"]