postgres:
	docker run --name bilitioo-db -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

psql:
	docker exec -it bilitioo-db psql -U root -d bilitioo

createdb:
	docker exec -it bilitioo-db createdb --username=root --owner=root bilitioo

dropdb:
	docker exec -it bilitioo-db dropdb bilitioo

new_migrate:
	migrate create -ext sql -dir migrate -seq $(name)