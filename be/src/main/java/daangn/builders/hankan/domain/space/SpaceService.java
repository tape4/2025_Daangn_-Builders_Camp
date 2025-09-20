package daangn.builders.hankan.domain.space;

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
        
        User owner = userRepository.findById(request.getOwnerId())
                .orElseThrow(() -> new IllegalArgumentException("Owner not found with id: " + request.getOwnerId()));

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
                .orElseThrow(() -> new IllegalArgumentException("Space not found with id: " + spaceId));
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
}