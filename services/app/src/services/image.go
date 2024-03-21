package services

import (
	"context"
	"errors"
	"fmt"
	"io"
	"stock-photo-api/domain/enum"
	"stock-photo-api/domain/model"
	"stock-photo-api/domain/repository"
	"stock-photo-api/pkg/config"
	"stock-photo-api/services/app/src/handlers/request"
	"time"

	"cloud.google.com/go/storage"
	"gorm.io/gorm"
)

type (
	ImageService interface {
		Upload(request.PostApiImagesUploadRequestBody) (err error)
		FindAll() ([]model.Image, error)
	}

	imageServiceStruct struct {
		db              *gorm.DB
		imageRepository repository.Image
	}
)

func NewImageService(c config.Config, db *gorm.DB, ir repository.Image) ImageService {
	return &imageServiceStruct{
		db:              db,
		imageRepository: ir,
	}
}

func (s *imageServiceStruct) FindAll() ([]model.Image, error) {
	results, err := s.imageRepository.FindAll(s.db)
	if err != nil {
		return nil, errors.New("imageRepository Create error")
	}

	return results, nil
}

func (s *imageServiceStruct) Upload(req request.PostApiImagesUploadRequestBody) (err error) {
	bucket := "stock-photo-images"
	object := req.File.Filename

	ctx := context.Background()

	client, err := storage.NewClient(context.Background())
	if err != nil {
		return fmt.Errorf("storage.NewClient: %w", err)
	}
	defer client.Close()

	f, err := req.File.Open()
	if err != nil {
		return fmt.Errorf("req.File.Open: %w", err)
	}
	defer f.Close()

	ctx, cancel := context.WithTimeout(ctx, time.Second*30)
	defer cancel()

	obj := client.Bucket(bucket).Object(object)

	w := obj.NewWriter(ctx)
	if _, err = io.Copy(w, f); err != nil {
		return fmt.Errorf("io.Copy: %w", err)
	}
	if err := w.Close(); err != nil {
		return fmt.Errorf("Writer.Close: %w", err)
	}

	image := model.Image{
		Title:          req.Title,
		PurchaseURL:    "https://storage.googleapis.com/stock-photo-images/" + object,
		ApprovalStatus: enum.PENDING,
	}

	err = s.imageRepository.Create(s.db, image)
	if err != nil {
		return errors.New("imageRepository Create error")
	}

	return nil
}
