package main

import (
	"net/http"
	"stock-photo-api/src/handlers"
	"stock-photo-api/src/pkg/config"
	"stock-photo-api/src/pkg/database"
	routes "stock-photo-api/src/router"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// @title StockPhoto API Documents
// @version 1.0
// @description StockPhoto API ドキュメント
func main() {
	config := config.LoadConfig()
	// logger, _ := logger.Init()

	db := database.Open(config.MySQL)
	defer db.Close()

	e := echo.New()

	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"http://localhost:3000"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))

	e.Server.Addr = ":8000"
	e.Use(middleware.Logger())

	handler := handlers.NewHandler(config, db.Master)

	routes.Init(e, handler)

	e.StartServer(e.Server)
}
