package router

import (
	"stock-photo-api/services/app/src/handlers"

	"github.com/labstack/echo/v4"
)

func Init(e *echo.Echo, h handlers.Handler) {
	app := e.Group("/api")

	images := app.Group("/images")
	images.GET("", h.Image.FindAll)
	images.POST("/upload", h.Image.Upload)

}
