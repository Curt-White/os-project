FROM mugen/ubuntu-build-essential
RUN apt-get install nasm
WORKDIR /src
COPY . .

RUN make build

RUN touch ./bootstrap.sh
RUN echo "while true; do echo 'Hit CTRL+C'; sleep 1; done" >> ./bootstrap.sh
RUN chmod +x ./bootstrap.sh

CMD [ "./bootstrap.sh" ]