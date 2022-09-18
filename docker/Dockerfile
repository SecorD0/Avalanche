FROM ubuntu

LABEL creator="SecorD >> 1package"
LABEL url="📦 All in https://t.me/OnePackage"

WORKDIR root

COPY entrypoint.sh .

RUN apt update && \
    apt upgrade -y && \
    apt install wget jq -y; \
    apt clean; \
    chmod +x entrypoint.sh

EXPOSE 9650 9651

ENTRYPOINT ["./entrypoint.sh"]
