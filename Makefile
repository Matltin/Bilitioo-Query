postgres:
	docker run --name bilitioo-db -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

psql:
	docker exec -it bilitioo-db psql -U root -d bilitioo

createdb:
	docker exec -it bilitioo-db createdb --username=root --owner=root bilitioo

dropdb:
	docker exec -it bilitioo-db dropdb bilitioo

migrateup:
	migrate -path migrate -database  "postgresql://root:secret@localhost:5432/bilitioo?sslmode=disable" -verbose up

migrateup1:
	migrate -path migrate -database  "postgresql://root:secret@localhost:5432/bilitioo?sslmode=disable" -verbose up 1

migratedown:
	migrate -path migrate -database "postgresql://root:secret@localhost:5432/bilitioo?sslmode=disable" -verbose down

migratedown1:
	migrate -path migrate -database "postgresql://root:secret@localhost:5432/bilitioo?sslmode=disable" -verbose down 1

new_migrate:
	migrate create -ext sql -dir migrate -seq $(name)

dockerup:
	docker-compose up -d

dockerstop:
	docker-compose down

dockerlogs:
	docker-compose logs -f

dockerstart:
	docker-compose start

dockerstop:
	docker-compose stop
	