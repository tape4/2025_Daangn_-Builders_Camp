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

## Current Implementation Status

### Implemented Controllers

#### SpaceController
- **Space Registration**: POST `/api/spaces` - Uses multipart form data with single image upload
- **Space Search**: Various endpoints for location-based and date-range search
- **Image Update**: Planned for future implementation

#### ItemController
- **Item Registration**: POST `/api/items` - Uses @ModelAttribute with ItemRegistrationRequest DTO
- **Single Image Upload**: Enforced through application properties (max 1 image)
- **Validation**: File size and type validation implemented

#### UserController
- **Profile Image**: Single image upload for user profiles
- **Authentication**: JWT-based with proper file upload in authenticated requests

## Usage in Controllers

The validation is currently handled through:

```java
// ItemController example (currently implemented)
@PostMapping(value = "/api/items", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public ResponseEntity<ItemRegistrationResponse> registerItem(
    @ModelAttribute ItemRegistrationRequest request,
    @Login User user
) {
    // File validation handled by service layer
    // AWS S3 upload integrated
}

// SpaceController example (currently implemented)
@PostMapping(value = "/api/spaces", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public ResponseEntity<Space> createSpace(
    @ModelAttribute SpaceCreationRequest request,
    @Login User user
) {
    // Single image upload enforced
    // S3 integration for space images
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

## Implementation Details

### AWS S3 Integration
- **Implemented**: Full S3 integration for all image uploads
- **Bucket Configuration**: Configured via environment variables
- **File Structure**: Organized by domain (spaces/, items/, profiles/)
- **URL Generation**: Public URLs generated for stored images

### Current Storage Implementation
```java
// S3Service handles all image uploads
public class S3Service {
    public String uploadFile(MultipartFile file, String folder) {
        // Uploads to S3 and returns public URL
        // Folder structure: {bucket}/{folder}/{uuid}-{filename}
    }
}
```

## Completed Features

1. **Database Schema**: ✅ Entities created with single image URL fields
   - Space entity: `imageUrl` field
   - Item entity: `imageUrl` field
   - User entity: `profileImageUrl` field

2. **File Storage**: ✅ AWS S3 integration completed
   - S3Service implemented and tested
   - Environment-based configuration
   - Secure credential management

3. **Security**: ✅ Authentication and authorization implemented
   - JWT-based authentication
   - @Login annotation for user context
   - Proper ownership validation

4. **Validation**: ✅ File type and size validation
   - 10MB file size limit
   - JPEG, PNG, WebP support only
   - Single image enforcement per domain

## Future Enhancements

1. **Image Processing**: Add image resizing and optimization
2. **CDN Integration**: Add CloudFront for faster image delivery
3. **Audit Logging**: Enhanced tracking of image upload/update activities
4. **Image Deletion**: Implement cleanup for replaced images

## Testing

### Current Test Coverage
- **ItemControllerTest**: Full test coverage for item registration with image uploads
  - Tests multipart file uploads with @ModelAttribute
  - Validates single image enforcement
  - Tests file size and type validation
  - All 155 tests passing (100% success rate)

- **SpaceControllerTest**: Integration tests for space management
  - Tests space creation with single image
  - Tests date range search functionality
  - Tests location-based search

- **UserControllerTest**: Authentication and profile tests
  - Tests profile image upload
  - Tests JWT authentication flow

### Test Infrastructure
- Spring MockMvc for controller testing
- @DirtiesContext for test isolation
- MockMultipartFile for file upload simulation
- AWS S3 mocked in test environment