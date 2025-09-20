package daangn.builders.hankan.domain.user;

import daangn.builders.hankan.domain.common.BaseEntity;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "users")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "phone_number", nullable = false, unique = true, length = 20)
    private String phoneNumber;
    
    @Column(name = "nickname", nullable = false, length = 50)
    private String nickname;
    
    @Column(name = "birth_date")
    private LocalDate birthDate;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "gender", length = 10)
    private Gender gender;
    
    @Column(name = "profile_image_url", length = 500)
    private String profileImageUrl;
    
    // 평점 관련 필드 (리뷰를 통해 계산됨)
    @Column(name = "rating")
    private Double rating = 0.0;
    
    @Column(name = "review_count")
    private Integer reviewCount = 0;
    
    
    @Builder
    public User(String phoneNumber, String nickname, LocalDate birthDate, 
                Gender gender, String profileImageUrl) {
        this.phoneNumber = phoneNumber;
        this.nickname = nickname;
        this.birthDate = birthDate;
        this.gender = gender;
        this.profileImageUrl = profileImageUrl;
    }
    
    // 비즈니스 메서드
    public void updateProfile(String nickname, String profileImageUrl) {
        if (nickname != null && !nickname.trim().isEmpty()) {
            this.nickname = nickname;
        }
        if (profileImageUrl != null) {
            this.profileImageUrl = profileImageUrl;
        }
    }
    
    public void updateRating(double rating, int reviewCount) {
        this.rating = rating;
        this.reviewCount = reviewCount;
    }
    
    public enum Gender {
        MALE, FEMALE, OTHER
    }
}