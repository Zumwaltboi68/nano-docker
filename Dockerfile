FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install NVM
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && echo "export NVM_DIR=\"$NVM_DIR\"" >> /root/.bashrc \
    && echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> /root/.bashrc \
    && echo "[ -s \"$NVM_DIR/bash_completion\" ] && \. \"$NVM_DIR/bash_completion\"" >> /root/.bashrc

# Install Node.js version 20.11.0
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 20.11.0 && nvm alias default 20.11.0"

# Install pnpm globally
RUN bash -c "source $NVM_DIR/nvm.sh && npm install -g pnpm"

# Clone the repository
RUN git clone https://github.com/DogeLeader/nano.git /nanobuild

# Set working directory
WORKDIR /nanobuild

# Install project dependencies and build
RUN bash -c "source $NVM_DIR/nvm.sh && pnpm install && pnpm run build"

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["bash", "-c", "source $NVM_DIR/nvm.sh && pnpm start"]
