FROM debian:latest

RUN apt-get update && apt-get install -y \
    npm \
    git

RUN git clone https://github.com/DogeLeader/nano.git /nanobuild

WORKDIR /nanobuild

RUN npm i -g pnpm && pnpm run build

EXPOSE 8080

CMD ["pnpm", "start"]




