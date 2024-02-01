export
DB_PORT := 3306
APP_PORT := 8000
DB_NAME := local
TEST_DB_NAME := test
APP_CONTAINER_NAME := stock-photo-app
DB_CONTAINER_NAME := stock-photo-db

ifneq (,$(wildcard ./.env))
	include .env
endif

DB_URL := mysql://user:password@tcp(${DB_CONTAINER_NAME}:${DB_PORT})/${DB_NAME}
TEST_DB_URL := mysql://user:password@tcp(${DB_CONTAINER_NAME}:${DB_PORT})/${TEST_DB_NAME}

.PHONY: init
init:
	@make up
	@make test-db-create
	@make migrate-up
	@make logs

.PHONY: up
up:
	docker compose up -d

.PHONY: upf
upf:
	docker compose up

.PHONY: stop
stop:
	docker compose stop

.PHONY: clean
clean:
	docker compose stop
	docker compose down

.PHONY: test-db-create
test-db-create:
	docker exec ${DB_CONTAINER_NAME} mysql -u user -ppassword -e "CREATE DATABASE test CHARACTER SET utf8mb4"

.PHONY: migrate-up
migrate-up:
	docker exec ${APP_CONTAINER_NAME} migrate -database "${DB_URL}?x-migrations-table=migrations" -path=src/migration/ddl up
	docker exec ${APP_CONTAINER_NAME} migrate -database "${DB_URL}?x-migrations-table=seed_migrations" -path=src/migration/seed/local up
	docker exec ${APP_CONTAINER_NAME} migrate -database "${TEST_DB_URL}?x-migrations-table=migrations" -path=src/migration/ddl up
	docker exec ${APP_CONTAINER_NAME} migrate -database "${TEST_DB_URL}?x-migrations-table=seed_migrations" -path=src/migration/seed/local up

.PHONY: migrate-down
migrate-down:
	docker exec ${APP_CONTAINER_NAME} migrate -database "${DB_URL}?x-migrations-table=seed_migrations" -path=src/migration/seed/local down -all
	docker exec ${APP_CONTAINER_NAME} migrate -database "${DB_URL}?x-migrations-table=migrations" -path=src/migration/ddl down -all
	docker exec ${APP_CONTAINER_NAME} migrate -database "${TEST_DB_URL}?x-migrations-table=seed_migrations" -path=src/migration/seed/local down -all
	docker exec ${APP_CONTAINER_NAME} migrate -database "${TEST_DB_URL}?x-migrations-table=migrations" -path=src/migration/ddl down -all

.PHONY: migrate-create
migrate-create:
	docker exec ${APP_CONTAINER_NAME} migrate create -ext sql -dir src/migration/ddl -format "20060102150405" -tz "Asia/Tokyo" ${NAME}

.PHONY: migrate-create-seed
migrate-create-seed:
	docker exec ${APP_CONTAINER_NAME} migrate create -ext sql -dir src/migration/seed/local -format "20060102150405" -tz "Asia/Tokyo" ${NAME}

.PHONY: swagger-generate
swagger-generate:
	docker exec ${APP_CONTAINER_NAME} swag init --parseDependency --parseInternal

.PHONY: test
test:
	docker-compose exec app go test -v ./...

.PHONY: logs
logs:
	docker compose logs -f
