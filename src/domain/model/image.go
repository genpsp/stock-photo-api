package model

import "time"

type Image struct {
	ID        uint
	Title     string
	URL       string
	CreatedAt time.Time
	UpdatedAt time.Time
}
