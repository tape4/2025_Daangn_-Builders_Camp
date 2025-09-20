package daangn.builders.hankan.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@Data
@Configuration
@ConfigurationProperties(prefix = "hankan.upload")
public class FileUploadConfig {
    
    private Space space = new Space();
    private Item item = new Item();
    private Profile profile = new Profile();
    private String maxFileSize = "10MB";
    private List<String> allowedTypes = List.of("image/jpeg", "image/png", "image/webp");
    
    @Data
    public static class Space {
        private Image image = new Image();
    }
    
    @Data
    public static class Item {
        private Image image = new Image();
    }
    
    @Data
    public static class Profile {
        private Image image = new Image();
    }
    
    @Data
    public static class Image {
        private int maxCount = 1;
    }
    
    public boolean isValidImageCount(MultipartFile[] files, ImageType imageType) {
        if (files == null) {
            return true;
        }
        
        int maxCount = switch (imageType) {
            case SPACE -> space.getImage().getMaxCount();
            case ITEM -> item.getImage().getMaxCount();
            case PROFILE -> profile.getImage().getMaxCount();
        };
        
        return files.length <= maxCount;
    }
    
    public boolean isValidImageType(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return true;
        }
        
        String contentType = file.getContentType();
        return contentType != null && allowedTypes.contains(contentType.toLowerCase());
    }
    
    public int getMaxImageCount(ImageType imageType) {
        return switch (imageType) {
            case SPACE -> space.getImage().getMaxCount();
            case ITEM -> item.getImage().getMaxCount();
            case PROFILE -> profile.getImage().getMaxCount();
        };
    }
    
    public enum ImageType {
        SPACE, ITEM, PROFILE
    }
}