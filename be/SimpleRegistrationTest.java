import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDate;
import org.json.JSONObject;

public class SimpleRegistrationTest {
    public static void main(String[] args) {
        try {
            HttpClient client = HttpClient.newHttpClient();
            
            // Create signup request body
            JSONObject requestBody = new JSONObject();
            requestBody.put("phoneNumber", "010-9876-5432");
            requestBody.put("nickname", "테스트유저");
            requestBody.put("birthDate", "1995-05-15");
            requestBody.put("gender", "MALE");
            requestBody.put("profileImageUrl", "https://example.com/profile.jpg");
            
            // Send signup request
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:8080/api/auth/signup"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                    .build();
            
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            System.out.println("Status Code: " + response.statusCode());
            System.out.println("Response Body: " + response.body());
            
            if (response.statusCode() == 201) {
                System.out.println("✅ Registration successful without verification code!");
            } else {
                System.out.println("❌ Registration failed. Status: " + response.statusCode());
            }
            
        } catch (Exception e) {
            System.err.println("Test failed with error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}