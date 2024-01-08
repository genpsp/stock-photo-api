package handlers

import (
	"net/http"
	"stock-photo-api/src/services"

	"github.com/labstack/echo/v4"
)

type (
	Image interface {
		Upload(c echo.Context) (err error)
	}
	imageStruct struct {
		ImageService services.ImageService
	}
)

func NewImage(s services.ImageService) Image {
	return &imageStruct{
		ImageService: s,
	}
}

func (h *imageStruct) Upload(c echo.Context) (err error) {
	if err := h.ImageService.Upload(); err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.NoContent(http.StatusNoContent)
}
