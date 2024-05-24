public class AuthorizationWrapper {
    public String id;
    public String username;
    public String email;
    public String firstName;
    public String lastName;
    public String gender;
    public String image;
    public String token;
    
    public static AuthorizationWrapper parse(String json) {
        return (authorizationWrapper) System.JSON.deserialize(json, authorizationWrapper.class);
    }
}