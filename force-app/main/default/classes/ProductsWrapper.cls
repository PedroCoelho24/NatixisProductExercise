public class ProductsWrapper {
    
    @AuraEnabled
    public List<IndividualProductWrapper> products;
    @AuraEnabled
    public Integer total;
    @AuraEnabled
    public Integer skip;
    @AuraEnabled
    public Integer limit_x;
    
    
    public class IndividualProductWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public Decimal price;
        @AuraEnabled
        public String discountPercentage;
        @AuraEnabled
        public Decimal rating;
        @AuraEnabled
        public Integer stock;
        @AuraEnabled
        public String brand;
        @AuraEnabled
        public String category;
        @AuraEnabled
        public String thumbnail;
        @AuraEnabled
        public List<String> images;
    }
    
    public static ProductsWrapper parse(String json) {
        return (ProductsWrapper) System.JSON.deserialize(json, ProductsWrapper.class);
    }
}