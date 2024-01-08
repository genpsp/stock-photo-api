package repository

import (
	"errors"
	"stock-photo-api/src/domain/model"

	"gorm.io/gorm"
)

type (
	Image interface {
		Create(db *gorm.DB, ImageEntity model.Image) (err error)
	}
	ImageStruct struct{}
)

func NewImageRepository() Image {
	return &ImageStruct{}
}

func (r ImageStruct) Create(db *gorm.DB, model model.Image) (err error) {
	err = db.Create(&model).Error
	if err != nil {
		return errors.New("create image failed")
	}

	return
}
