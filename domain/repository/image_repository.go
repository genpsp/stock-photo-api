package repository

import (
	"errors"
	"stock-photo-api/domain/model"

	"gorm.io/gorm"
)

type (
	Image interface {
		FindAll(db *gorm.DB) ([]model.Image, error)
		Create(db *gorm.DB, ImageEntity model.Image) error
	}
	ImageStruct struct{}
)

func NewImageRepository() Image {
	return &ImageStruct{}
}

func (r ImageStruct) FindAll(db *gorm.DB) (models []model.Image, err error) {
	err = db.Find(&models).Error
	if err != nil {
		return nil, errors.New("create image failed")
	}

	return
}

func (r ImageStruct) Create(db *gorm.DB, model model.Image) (err error) {
	err = db.Create(&model).Error
	if err != nil {
		return errors.New("create image failed")
	}

	return
}
