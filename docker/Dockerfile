FROM golang:1.20-bullseye

ENV TZ=Asia/Tokyo

WORKDIR /app

COPY go.* ./
RUN go mod download

COPY . ./

# Build the binary.
RUN go build -v -o server

# Run the web service on container startup.
CMD ["/app/server"]
