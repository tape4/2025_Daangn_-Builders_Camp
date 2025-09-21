package daangn.builders.hankan.common.service;

import daangn.builders.hankan.config.FileUploadConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class FileUploadValidationService {
    
    private final FileUploadConfig fileUploadConfig;
    
    public ValidationResult validateSpaceImages(MultipartFile[] images) {
        return validateImages(images, FileUploadConfig.ImageType.SPACE);
    }
    
    public ValidationResult validateItemImages(MultipartFile[] images) {
        return validateImages(images, FileUploadConfig.ImageType.ITEM);
    }
    
    public ValidationResult validateProfileImages(MultipartFile[] images) {
        return validateImages(images, FileUploadConfig.ImageType.PROFILE);
    }
    
    public ValidationResult validateImages(MultipartFile[] images, FileUploadConfig.ImageType imageType) {
        List<String> errors = new ArrayList<>();
        
        // Check if image count exceeds limit
        if (!fileUploadConfig.isValidImageCount(images, imageType)) {
            int maxCount = fileUploadConfig.getMaxImageCount(imageType);
            errors.add(String.format("Image count exceeds limit. Maximum allowed: %d, provided: %d", 
                    maxCount, images != null ? images.length : 0));
        }
        
        // Check each image type
        if (images != null) {
            for (int i = 0; i < images.length; i++) {
                MultipartFile image = images[i];
                if (!image.isEmpty() && !fileUploadConfig.isValidImageType(image)) {
                    errors.add(String.format("Invalid image type for file %d. Allowed types: %s, provided: %s", 
                            i + 1, String.join(", ", fileUploadConfig.getAllowedTypes()), image.getContentType()));
                }
            }
        }
        
        boolean isValid = errors.isEmpty();
        if (!isValid) {
            log.warn("Image validation failed for {} images: {}", imageType, errors);
        }
        
        return new ValidationResult(isValid, errors);
    }
    
    public static class ValidationResult {
        private final boolean valid;
        private final List<String> errors;
        
        public ValidationResult(boolean valid, List<String> errors) {
            this.valid = valid;
            this.errors = errors != null ? errors : new ArrayList<>();
        }
        
        public boolean isValid() {
            return valid;
        }
        
        public List<String> getErrors() {
            return errors;
        }
        
        public String getErrorMessage() {
            return String.join("; ", errors);
        }
    }
}