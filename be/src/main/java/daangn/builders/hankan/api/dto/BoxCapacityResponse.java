package daangn.builders.hankan.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class BoxCapacityResponse {
    @JsonProperty("xsCount")
    private int xsCount;
    
    @JsonProperty("sCount")
    private int sCount;
    
    @JsonProperty("mCount")
    private int mCount;
    
    @JsonProperty("lCount")
    private int lCount;
    
    @JsonProperty("xlCount")
    private int xlCount;
    
    @JsonProperty("totalCount")
    private int totalCount;
}