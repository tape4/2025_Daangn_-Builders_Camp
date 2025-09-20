package daangn.builders.hankan.domain.user;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    /**
     * 전화번호로 사용자 조회
     */
    Optional<User> findByPhoneNumber(String phoneNumber);
    
    /**
     * 전화번호 존재 여부 확인
     */
    boolean existsByPhoneNumber(String phoneNumber);
    
    /**
     * 닉네임 존재 여부 확인 (중복 체크용)
     */
    boolean existsByNickname(String nickname);
    
    /**
     * 특정 사용자 제외하고 닉네임 중복 체크 (프로필 수정시 사용)
     */
    boolean existsByNicknameAndIdNot(String nickname, Long id);
    
    /**
     * 사용자의 평균 평점과 리뷰 수 계산
     */
    @Query("SELECT AVG(r.rating), COUNT(r) FROM Review r WHERE r.reviewedUser.id = :userId")
    Object[] calculateUserRating(@Param("userId") Long userId);
}