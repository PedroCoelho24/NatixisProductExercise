public class ProductsWrapper {
    
    List<IndividualProductWrapper> products;
    Integer total;
    Integer skip;
    Integer limit_x;
    
    
    public class IndividualProductWrapper {
        public String id;
        public String title;
        public String description;
        public String price;
        public String discountPercentage;
        public String rating;
        public String stock;
        public String brand;
        public String category;
        public String thumbnail;
        public List<String> images;
    }
    
    public static ProductsWrapper parse(String json) {
        return (ProductsWrapper) System.JSON.deserialize(json, ProductsWrapper.class);
    }
}