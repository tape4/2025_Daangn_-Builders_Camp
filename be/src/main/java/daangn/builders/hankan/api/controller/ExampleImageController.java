package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.common.service.FileUploadValidationService;
import daangn.builders.hankan.common.validation.ValidItemImages;
import daangn.builders.hankan.common.validation.ValidSpaceImages;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Encoding;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/example")
@RequiredArgsConstructor
@Validated
@Tag(name = "Example", description = "Example API demonstrating image upload validation")
public class ExampleImageController {
    
    private final FileUploadValidationService validationService;
    
    @Operation(
            summary = "Upload space image",
            description = "Validates that only 1 space image is uploaded with correct format"
    )
    @RequestBody(
            content = @Content(
                    mediaType = MediaType.MULTIPART_FORM_DATA_VALUE,
                    encoding = @Encoding(name = "image", contentType = "image/*")
            )
    )
    @ApiResponse(responseCode = "200", description = "Image uploaded successfully")
    @ApiResponse(responseCode = "400", description = "Validation failed", 
                 content = @Content(schema = @Schema(implementation = Map.class)))
    @PostMapping(value = "/spaces/images", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> uploadSpaceImages(
            @Parameter(description = "Space image file", 
                      content = @Content(mediaType = "image/*"))
            @RequestParam("image") MultipartFile image) {
        
        log.info("Uploading space image: {}", image != null ? image.getOriginalFilename() : "null");
        
        // Convert single file to array for validation
        MultipartFile[] images = image != null ? new MultipartFile[]{image} : new MultipartFile[0];
        
        // Validate the image
        FileUploadValidationService.ValidationResult validationResult = 
                validationService.validateSpaceImages(images);
        
        if (!validationResult.isValid()) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", validationResult.getErrorMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Space image validated successfully");
        response.put("fileName", image != null ? image.getOriginalFilename() : null);
        response.put("fileSize", image != null ? image.getSize() : 0);
        
        return ResponseEntity.ok(response);
    }
    
    @Operation(
            summary = "Upload item image during check-in",
            description = "Validates that only 1 item image is uploaded with correct format"
    )
    @RequestBody(
            content = @Content(
                    mediaType = MediaType.MULTIPART_FORM_DATA_VALUE,
                    encoding = @Encoding(name = "itemImage", contentType = "image/*")
            )
    )
    @ApiResponse(responseCode = "200", description = "Image uploaded successfully")
    @ApiResponse(responseCode = "400", description = "Validation failed", 
                 content = @Content(schema = @Schema(implementation = Map.class)))
    @PostMapping(value = "/reservations/{reservationId}/checkin/images", 
                 consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> uploadItemImages(
            @PathVariable Long reservationId,
            @Parameter(description = "Item image file",
                      content = @Content(mediaType = "image/*"))
            @RequestParam("itemImage") MultipartFile itemImage) {
        
        log.info("Uploading item image: {} for reservation {}", 
                itemImage != null ? itemImage.getOriginalFilename() : "null", reservationId);
        
        // Convert single file to array for validation
        MultipartFile[] images = itemImage != null ? new MultipartFile[]{itemImage} : new MultipartFile[0];
        
        // Validate the image
        FileUploadValidationService.ValidationResult validationResult = 
                validationService.validateItemImages(images);
        
        if (!validationResult.isValid()) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", validationResult.getErrorMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Item image validated successfully");
        response.put("reservationId", reservationId);
        response.put("fileName", itemImage != null ? itemImage.getOriginalFilename() : null);
        response.put("fileSize", itemImage != null ? itemImage.getSize() : 0);
        
        return ResponseEntity.ok(response);
    }
}