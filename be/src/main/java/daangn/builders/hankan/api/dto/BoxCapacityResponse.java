package daangn.builders.hankan.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Builder
@AllArgsConstructor
public class BoxCapacityResponse {
    private int xsCount;
    private int sCount;
    private int mCount;
    private int lCount;
    private int xlCount;
    private int totalCount;
    
    @JsonProperty("xsCount")
    public int getXsCount() {
        return xsCount;
    }
    
    @JsonProperty("sCount")
    public int getSCount() {
        return sCount;
    }
    
    @JsonProperty("mCount")
    public int getMCount() {
        return mCount;
    }
    
    @JsonProperty("lCount")
    public int getLCount() {
        return lCount;
    }
    
    @JsonProperty("xlCount")
    public int getXlCount() {
        return xlCount;
    }
    
    @JsonProperty("totalCount")
    public int getTotalCount() {
        return totalCount;
    }
}