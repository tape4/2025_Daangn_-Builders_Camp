package daangn.builders.hankan.common.validation;

import daangn.builders.hankan.common.service.FileUploadValidationService;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@RequiredArgsConstructor
public class SpaceImageValidator implements ConstraintValidator<ValidSpaceImages, MultipartFile[]> {
    
    private final FileUploadValidationService validationService;
    
    @Override
    public void initialize(ValidSpaceImages constraintAnnotation) {
        // Initialization logic if needed
    }
    
    @Override
    public boolean isValid(MultipartFile[] images, ConstraintValidatorContext context) {
        if (images == null) {
            return true; // Let @NotNull handle null validation if required
        }
        
        FileUploadValidationService.ValidationResult result = validationService.validateSpaceImages(images);
        
        if (!result.isValid()) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate(result.getErrorMessage())
                    .addConstraintViolation();
        }
        
        return result.isValid();
    }
}