package handlers

import (
	"stock-photo-api/src/domain/repository"
	"stock-photo-api/src/pkg/config"
	"stock-photo-api/src/services"

	"gorm.io/gorm"
)

type (
	Handler struct {
		Image Image
	}
)

func NewHandler(c config.Config, db *gorm.DB) Handler {

	ir := repository.NewImageRepository()

	imageService := services.NewImageService(c, db, ir)

	return Handler{
		Image: NewImage(imageService),
	}
}
