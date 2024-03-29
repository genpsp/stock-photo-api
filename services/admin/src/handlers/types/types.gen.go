// Package oapi provides primitives to interact with the openapi HTTP API.
//
// Code generated by github.com/deepmap/oapi-codegen/v2 version v2.1.0 DO NOT EDIT.
package oapi

import (
	openapi_types "github.com/oapi-codegen/runtime/types"
)

// EchoHTTPError defines model for echo.HTTPError.
type EchoHTTPError struct {
	Message *interface{} `json:"message,omitempty"`
}

// ModelImage defines model for model.Image.
type ModelImage struct {
	CreatedAt *string `json:"createdAt,omitempty"`
	Id        *int    `json:"id,omitempty"`
	Title     *string `json:"title,omitempty"`
	UpdatedAt *string `json:"updatedAt,omitempty"`
	Url       *string `json:"url,omitempty"`
}

// PostApiImagesUploadMultipartBody defines parameters for PostApiImagesUpload.
type PostApiImagesUploadMultipartBody struct {
	// File 画像ファイル
	File openapi_types.File `json:"file"`

	// Title 画像タイトル
	Title string `json:"title"`
}

// PostApiImagesUploadMultipartRequestBody defines body for PostApiImagesUpload for multipart/form-data ContentType.
type PostApiImagesUploadMultipartRequestBody PostApiImagesUploadMultipartBody
