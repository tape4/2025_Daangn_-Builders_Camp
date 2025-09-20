package daangn.builders.hankan.domain.space;

import daangn.builders.hankan.common.exception.EntityNotFoundException;
import daangn.builders.hankan.common.exception.InvalidBoxCapacityException;
import daangn.builders.hankan.common.exception.SpaceNotFoundException;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class SpaceService {

    private final SpaceRepository spaceRepository;
    private final UserRepository userRepository;

    @Transactional
    public Space registerSpace(SpaceRegistrationRequest request) {
        log.info("Registering new space: {} at {}, {}", request.getName(), request.getLatitude(), request.getLongitude());
        
        // 박스 용량 검증
        validateBoxCapacities(request.getBoxCapacityXs(), request.getBoxCapacityS(), 
                              request.getBoxCapacityM(), request.getBoxCapacityL(), 
                              request.getBoxCapacityXl());
        
        User owner = userRepository.findById(request.getOwnerId())
                .orElseThrow(() -> new EntityNotFoundException("Owner not found with id: " + request.getOwnerId()));

        Space space = Space.builder()
                .name(request.getName())
                .description(request.getDescription())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .address(request.getAddress())
                .imageUrl(request.getImageUrl())
                .owner(owner)
                .availableStartDate(request.getAvailableStartDate())
                .availableEndDate(request.getAvailableEndDate())
                .boxCapacityXs(request.getBoxCapacityXs())
                .boxCapacityS(request.getBoxCapacityS())
                .boxCapacityM(request.getBoxCapacityM())
                .boxCapacityL(request.getBoxCapacityL())
                .boxCapacityXl(request.getBoxCapacityXl())
                .build();

        Space savedSpace = spaceRepository.save(space);
        log.info("Space registered successfully with id: {}", savedSpace.getId());
        
        return savedSpace;
    }

    public Space findById(Long spaceId) {
        return spaceRepository.findById(spaceId)
                .orElseThrow(() -> new SpaceNotFoundException(spaceId));
    }

    public List<Space> findAvailableSpacesOnDate(LocalDate date) {
        return spaceRepository.findByAvailableDate(date);
    }

    public Page<Object[]> findSpacesNearLocation(Double latitude, Double longitude, double radiusKm, Pageable pageable) {
        return spaceRepository.findByLocationWithinRadius(latitude, longitude, radiusKm, pageable);
    }

    public Page<Object[]> findSpacesNearLocationOnDate(Double latitude, Double longitude, double radiusKm, 
                                                      LocalDate date, Pageable pageable) {
        return spaceRepository.findByLocationAndDate(latitude, longitude, radiusKm, date, pageable);
    }

    public Page<Space> findByOwner(Long ownerId, Pageable pageable) {
        return spaceRepository.findByOwnerId(ownerId, pageable);
    }

    public Page<Space> findTopRatedSpaces(Pageable pageable) {
        // 기본 정렬이 rating desc로 이미 설정되어 있어서 별도 정렬 처리 불필요
        return spaceRepository.findAllByOrderByRatingDesc(pageable);
    }

    @Transactional
    public Space updateSpaceImage(Long spaceId, String imageUrl) {
        Space space = findById(spaceId);
        space.updateImage(imageUrl);
        return space;
    }

    @Transactional
    public Space updateAvailabilityPeriod(Long spaceId, LocalDate startDate, LocalDate endDate) {
        Space space = findById(spaceId);
        space.updateAvailablePeriod(startDate, endDate);
        return space;
    }

    @Transactional
    public Space updateBoxCapacities(Long spaceId, Integer xs, Integer s, Integer m, Integer l, Integer xl) {
        // 박스 용량 검증 (음수 값 및 총합 0 체크)
        validateBoxCapacities(xs, s, m, l, xl);
        
        Space space = findById(spaceId);
        space.updateBoxCapacity(xs, s, m, l, xl);
        return space;
    }

    @Transactional
    public Space updateRating(Long spaceId, double newRating, int newReviewCount) {
        Space space = findById(spaceId);
        space.updateRating(newRating, newReviewCount);
        return space;
    }

    public boolean isSpaceAvailableOnDate(Long spaceId, LocalDate date) {
        Space space = findById(spaceId);
        return space.isAvailableOn(date);
    }

    public int getTotalBoxCount(Long spaceId) {
        Space space = findById(spaceId);
        return space.getTotalBoxCount();
    }
    
    private void validateBoxCapacities(Integer xs, Integer s, Integer m, Integer l, Integer xl) {
        // 음수 값 검증
        if ((xs != null && xs < 0) || (s != null && s < 0) || (m != null && m < 0) || 
            (l != null && l < 0) || (xl != null && xl < 0)) {
            throw new InvalidBoxCapacityException("박스 용량은 음수가 될 수 없습니다. 0 이상의 값을 입력해주세요.");
        }
        
        int totalCapacity = (xs != null ? xs : 0) + 
                          (s != null ? s : 0) + 
                          (m != null ? m : 0) + 
                          (l != null ? l : 0) + 
                          (xl != null ? xl : 0);
        
        if (totalCapacity == 0) {
            throw new InvalidBoxCapacityException("공간의 총 박스 용량은 0개일 수 없습니다. 최소 1개 이상의 박스를 설정해주세요.");
        }
        
        log.info("Box capacity validation passed. Total capacity: {}", totalCapacity);
    }
}