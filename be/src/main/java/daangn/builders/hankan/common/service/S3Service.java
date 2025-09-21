package daangn.builders.hankan.common.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;
import software.amazon.awssdk.services.s3.presigner.model.PresignedGetObjectRequest;

import java.io.IOException;
import java.net.URL;
import java.time.Duration;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class S3Service {
    
    private final S3Client s3Client;
    private final S3Presigner s3Presigner;
    
    @Value("${aws.s3.bucket-name}")
    private String bucketName;
    
    @Value("${aws.s3.region}")
    private String region;
    
    @Value("${aws.s3.profile-image-path}")
    private String profileImagePath;
    
    @Value("${aws.s3.space-image-path}")
    private String spaceImagePath;
    
    @Value("${aws.s3.item-image-path}")
    private String itemImagePath;
    
    public enum ImageType {
        PROFILE, SPACE, ITEM
    }
    
    /**
     * 이미지 업로드
     */
    public String uploadImage(MultipartFile file, ImageType imageType) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("파일이 비어있습니다.");
        }
        
        // 파일 확장자 검증
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !isValidImageFile(originalFilename)) {
            throw new IllegalArgumentException("지원하지 않는 파일 형식입니다.");
        }
        
        String fileExtension = getFileExtension(originalFilename);
        String fileName = generateFileName(fileExtension);
        String key = getKeyPath(imageType) + fileName;
        
        try {
            // S3에 파일 업로드
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .contentType(file.getContentType())
                    .build();
            
            s3Client.putObject(putObjectRequest, 
                    RequestBody.fromInputStream(file.getInputStream(), file.getSize()));
            
            // 업로드된 파일의 URL 반환
            String fileUrl = String.format("https://%s.s3.%s.amazonaws.com/%s", 
                    bucketName, region, key);
            
            log.info("S3 파일 업로드 성공: {}", fileUrl);
            return fileUrl;
            
        } catch (IOException e) {
            log.error("S3 파일 업로드 실패: {}", e.getMessage());
            throw new RuntimeException("파일 업로드에 실패했습니다.", e);
        } catch (S3Exception e) {
            log.error("S3 서비스 오류: {}", e.getMessage());
            throw new RuntimeException("S3 서비스 오류가 발생했습니다.", e);
        }
    }
    
    /**
     * 이미지 삭제
     */
    public void deleteImage(String fileUrl) {
        if (fileUrl == null || fileUrl.isEmpty()) {
            return;
        }
        
        try {
            String key = extractKeyFromUrl(fileUrl);
            
            DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();
            
            s3Client.deleteObject(deleteObjectRequest);
            log.info("S3 파일 삭제 성공: {}", key);
            
        } catch (S3Exception e) {
            log.error("S3 파일 삭제 실패: {}", e.getMessage());
            // 삭제 실패는 로그만 남기고 예외를 던지지 않음
        }
    }
    
    /**
     * 프리사인드 URL 생성 (임시 접근용)
     */
    public String generatePresignedUrl(String fileUrl, Duration duration) {
        if (fileUrl == null || fileUrl.isEmpty()) {
            return null;
        }
        
        try {
            String key = extractKeyFromUrl(fileUrl);
            
            GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();
            
            GetObjectPresignRequest presignRequest = GetObjectPresignRequest.builder()
                    .signatureDuration(duration)
                    .getObjectRequest(getObjectRequest)
                    .build();
            
            PresignedGetObjectRequest presignedRequest = s3Presigner.presignGetObject(presignRequest);
            URL url = presignedRequest.url();
            
            return url.toString();
            
        } catch (Exception e) {
            log.error("프리사인드 URL 생성 실패: {}", e.getMessage());
            return fileUrl; // 실패 시 원본 URL 반환
        }
    }
    
    /**
     * 파일명 생성
     */
    private String generateFileName(String fileExtension) {
        return UUID.randomUUID().toString() + "." + fileExtension;
    }
    
    /**
     * 파일 확장자 추출
     */
    private String getFileExtension(String filename) {
        int lastDotIndex = filename.lastIndexOf(".");
        if (lastDotIndex == -1) {
            throw new IllegalArgumentException("파일 확장자가 없습니다.");
        }
        return filename.substring(lastDotIndex + 1).toLowerCase();
    }
    
    /**
     * 이미지 타입별 경로 반환
     */
    private String getKeyPath(ImageType imageType) {
        return switch (imageType) {
            case PROFILE -> profileImagePath;
            case SPACE -> spaceImagePath;
            case ITEM -> itemImagePath;
        };
    }
    
    /**
     * URL에서 S3 키 추출
     */
    private String extractKeyFromUrl(String fileUrl) {
        // https://bucket-name.s3.region.amazonaws.com/key 형식에서 key 추출
        String prefix = String.format("https://%s.s3.%s.amazonaws.com/", bucketName, region);
        if (fileUrl.startsWith(prefix)) {
            return fileUrl.substring(prefix.length());
        }
        
        // https://s3.region.amazonaws.com/bucket-name/key 형식에서 key 추출
        String altPrefix = String.format("https://s3.%s.amazonaws.com/%s/", region, bucketName);
        if (fileUrl.startsWith(altPrefix)) {
            return fileUrl.substring(altPrefix.length());
        }
        
        throw new IllegalArgumentException("잘못된 S3 URL 형식입니다.");
    }
    
    /**
     * 유효한 이미지 파일 확인
     */
    private boolean isValidImageFile(String filename) {
        String[] allowedExtensions = {"jpg", "jpeg", "png", "gif", "webp"};
        String fileExtension = getFileExtension(filename);
        
        for (String ext : allowedExtensions) {
            if (ext.equalsIgnoreCase(fileExtension)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 파일 크기 검증
     */
    public void validateFileSize(MultipartFile file, long maxSizeInMB) {
        long maxSizeInBytes = maxSizeInMB * 1024 * 1024;
        if (file.getSize() > maxSizeInBytes) {
            throw new IllegalArgumentException(
                String.format("파일 크기가 %dMB를 초과합니다.", maxSizeInMB)
            );
        }
    }
}