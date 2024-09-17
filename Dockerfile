FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install NVM
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && echo "export NVM_DIR=\"$NVM_DIR\"" >> /root/.bashrc \
    && echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> /root/.bashrc \
    && echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"" >> /root/.bashrc \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install node \
    && nvm alias default node \
    && npm install -g pnpm  # Install pnpm globally

# Clone the repository
RUN git clone https://github.com/DogeLeader/nano.git /nanobuild

# Set working directory
WORKDIR /nanobuild

# Install project dependencies and build
RUN npm i -g pnpm && pnpm install && pnpm run build

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["pnpm", "start"]
