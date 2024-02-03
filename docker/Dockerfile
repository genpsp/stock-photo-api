FROM golang:1.20-bullseye

ENV TZ=Asia/Tokyo

WORKDIR /app

COPY go.* ./
RUN go mod download

COPY . ./

RUN go build -v -o server

CMD ["/app/server"]
