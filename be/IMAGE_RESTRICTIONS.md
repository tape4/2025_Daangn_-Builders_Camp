# Image Upload Restrictions Implementation

This document explains the implementation of the image upload restrictions that limit both space images and item images to 1 each.

## Changes Made

### 1. API Documentation Updates (`API.md`)
- Updated all API endpoints to use singular image parameters and responses
- Changed `images: [File, File, ...]` to `image: [File]` for space registration
- Changed `itemImages: [File, File, ...]` to `itemImage: [File]` for check-in
- Updated response structures to use `imageUrl` instead of `imageUrls` arrays
- Modified space image endpoint from POST `/api/spaces/{spaceId}/images` to PUT `/api/spaces/{spaceId}/image`
- Updated file upload limitations from "최대 5개/10개" to "1개" for both space and item images

### 2. Configuration Properties (`application.properties`)
Added configuration properties to enforce image limits:
```properties
hankan.upload.space.image.max-count=1
hankan.upload.item.image.max-count=1
hankan.upload.profile.image.max-count=1
hankan.upload.max-file-size=10MB
hankan.upload.allowed-types=image/jpeg,image/png,image/webp
```

### 3. Configuration Class (`FileUploadConfig.java`)
- Created a Spring Configuration class that binds the upload restriction properties
- Provides validation methods:
  - `isValidImageCount(MultipartFile[], ImageType)` - Validates image count against limits
  - `isValidImageType(MultipartFile)` - Validates image file types
  - `getMaxImageCount(ImageType)` - Returns the maximum allowed image count per type
- Supports three image types: SPACE, ITEM, and PROFILE

### 4. Validation Service (`FileUploadValidationService.java`)
- Service class that provides centralized validation logic
- Methods for validating different image types:
  - `validateSpaceImages(MultipartFile[])`
  - `validateItemImages(MultipartFile[])`
  - `validateProfileImages(MultipartFile[])`
- Returns detailed validation results with error messages

### 5. Custom Validation Annotations
Created custom validation annotations for automatic validation:

#### `@ValidSpaceImages` and `SpaceImageValidator.java`
- Annotation for validating space image uploads
- Enforces single image limit for spaces
- Validates image types

#### `@ValidItemImages` and `ItemImageValidator.java`
- Annotation for validating item image uploads
- Enforces single image limit for items during check-in
- Validates image types

### 6. Example Controller (`ExampleImageController.java`)
- Demonstrates how to use the validation annotations in controller methods
- Shows proper error handling for validation failures
- Includes Swagger/OpenAPI documentation

## Usage in Controllers

When implementing actual space and item controllers, use the validation annotations:

```java
@PostMapping(value = "/api/spaces", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public ResponseEntity<?> createSpace(
    @RequestParam("image") @ValidSpaceImages MultipartFile[] images,
    // other parameters
) {
    // Implementation
}

@PostMapping(value = "/api/reservations/{id}/checkin", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public ResponseEntity<?> checkIn(
    @PathVariable Long id,
    @RequestParam("itemImage") @ValidItemImages MultipartFile[] images,
    // other parameters
) {
    // Implementation
}
```

## Validation Behavior

### Single Image Enforcement
- Space images: Maximum 1 image allowed
- Item images: Maximum 1 image allowed
- Profile images: Maximum 1 image allowed

### File Type Validation
- Only accepts: JPG, PNG, WebP formats
- Maximum file size: 10MB (configurable)

### Error Responses
When validation fails, the system will return HTTP 400 with detailed error messages indicating:
- Number of images provided vs. allowed
- Invalid file types if any
- Specific validation failures

## Future Enhancements

1. **Database Schema**: Create entities for spaces, items, and reservations with single image URL fields
2. **File Storage**: Implement actual file upload to cloud storage (S3, etc.)
3. **Image Processing**: Add image resizing and optimization
4. **Security**: Add authentication and authorization checks
5. **Audit Logging**: Track image upload/update activities

## Testing

The implementation includes:
- Unit tests can be added for `FileUploadValidationService`
- Integration tests can be added for the example controller endpoints
- The build passes successfully with the new validation infrastructure in place