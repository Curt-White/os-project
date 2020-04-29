FROM mugen/ubuntu-build-essential
WORKDIR /src
COPY . .
RUN make