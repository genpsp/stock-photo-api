package request

import (
	"mime/multipart"
)

type PostApiImagesUploadRequestBody struct {
	Title string
	File  *multipart.FileHeader
}

func PostApiImagesUploadRequest(title string, file *multipart.FileHeader) PostApiImagesUploadRequestBody {
	return PostApiImagesUploadRequestBody{
		Title: title,
		File:  file,
	}
}
