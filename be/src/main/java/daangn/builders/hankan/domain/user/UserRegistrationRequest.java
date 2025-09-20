package daangn.builders.hankan.domain.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserRegistrationRequest {
    
    private String phoneNumber;
    private String nickname;
    private LocalDate birthDate;
    private Gender gender;
    private String profileImageUrl;
}