package daangn.builders.hankan.domain.space;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SpaceRegistrationRequest {
    
    private String name;
    private String description;
    private Double latitude;
    private Double longitude;
    private String address;
    private String imageUrl;
    private Long ownerId;
    private LocalDate availableStartDate;
    private LocalDate availableEndDate;
    private Integer boxCapacityXs;
    private Integer boxCapacityS;
    private Integer boxCapacityM;
    private Integer boxCapacityL;
    private Integer boxCapacityXl;
}