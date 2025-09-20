package daangn.builders.hankan.api.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class BoxCapacityResponse {
    private int xsCount;
    private int sCount;
    private int mCount;
    private int lCount;
    private int xlCount;
    private int totalCount;
}