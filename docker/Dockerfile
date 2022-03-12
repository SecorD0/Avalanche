FROM ubuntu

LABEL creator="SecorD | Let's Node"
LABEL url="https://t.me/letskynode — node Community"

WORKDIR root

COPY entrypoint.sh .

RUN apt update && \
    apt upgrade -y && \
    apt install wget jq -y; \
    apt clean; \
	chmod +x entrypoint.sh

EXPOSE 9650 9651

ENTRYPOINT ["./entrypoint.sh"]
