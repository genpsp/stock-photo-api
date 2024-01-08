package main

import (
	"stock-photo-api/src/handlers"
	"stock-photo-api/src/pkg/config"
	"stock-photo-api/src/pkg/database"
	routes "stock-photo-api/src/router"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	config := config.LoadConfig()

	db := database.Open(config.MySQL)
	defer db.Close()

	e := echo.New()

	e.Server.Addr = ":8000"
	e.Use(middleware.Logger())
	handler := handlers.NewHandler(config, db.Master)

	routes.Init(e, handler)

	e.StartServer(e.Server)
}
