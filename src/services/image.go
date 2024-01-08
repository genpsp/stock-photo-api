package services

import (
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"stock-photo-api/src/domain/model"
	"stock-photo-api/src/domain/repository"
	"stock-photo-api/src/pkg/config"
	"time"

	"cloud.google.com/go/storage"
	"gorm.io/gorm"
)

type (
	ImageService interface {
		Upload() (err error)
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

func (s *imageServiceStruct) Upload() (err error) {
	bucket := "stock-photo-images-test"
	object := "object-name"

	ctx := context.Background()

	client, err := storage.NewClient(ctx)
	if err != nil {
		return fmt.Errorf("storage.NewClient: %w", err)
	}
	defer client.Close()

	f, err := os.Open("./src/landscape001.jpg")
	if err != nil {
		return fmt.Errorf("os.Open: %w", err)
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
	fmt.Fprintf(w, "Blob %v uploaded.\n", object)

	image := model.Image{
		Title: "テスト画像",
		URL:   "https://storage.cloud.google.com/stock-photo-images-test/object-name",
	}

	err = s.imageRepository.Create(s.db, image)
	if err != nil {
		return errors.New("imageRepository Create error")
	}

	return nil
}
