package model

import (
	"stock-photo-api/domain/enum"

	"gorm.io/gorm"
)

type Image struct {
	gorm.Model
	UserID         uint                     `json:"userId"`
	Title          string                   `json:"title"`
	ThumbnailURL   string                   `json:"thumbnailUrl"`
	DetailURL      string                   `json:"detailUrl"`
	PurchaseURL    string                   `json:"purchaseUrl"`
	ApprovalStatus enum.ImageApprovalStatus `json:"approvalStatus"`
}
