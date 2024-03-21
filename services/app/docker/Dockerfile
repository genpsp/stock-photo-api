FROM golang:1.22-bullseye

ENV TZ=Asia/Tokyo

WORKDIR /app

COPY ../go.* ./
RUN go mod download

COPY ../ ./

RUN go build -v -o server ./services/app

CMD ["/app/server"]
