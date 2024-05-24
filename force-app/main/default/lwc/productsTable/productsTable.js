import { LightningElement, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductTableController.doCallout';
import getMetadataInfo from '@salesforce/apex/ProductTableController.doCallout';

import { RefreshEvent } from "lightning/refresh";


const columns = [
	{
        label: 'Thumbnail',
        fieldName: 'thumbnail',
        type: 'customImage',
        typeAttributes: { altText: { fieldName: 'name' }, width: '200', height: '200' },
		cellAttributes: { alignment: 'center' } 
    },
	{ label: 'Category', fieldName: 'category', cellAttributes: { alignment: 'center' } },
	{ label: 'Title', fieldName: 'title', cellAttributes: { alignment: 'center' } },
	{ label: 'Brand', fieldName: 'brand', cellAttributes: { alignment: 'center' } },
	{ label: 'Description', fieldName: 'description', cellAttributes: { alignment: 'center' } },
	{ label: 'Price', fieldName: 'price', cellAttributes: { alignment: 'center' } },
	{ label: 'Stock', fieldName: 'stock', cellAttributes: { alignment: 'center' } }
	
	
];


export default class ProductsTable extends LightningElement {

	@track products = [];
	totalProducts;
	tableLoading = true;
	emptyTable = true;
	filterTitle = [];
	filterBrand = [];
	filterCategory = [];
	
	error = "";
	errorCheck = false;
	columns = columns;

	@track selectedTitle = "";
	@track selectedBrand = "";
	@track selectedCategory = "";
	

	connectedCallback() {
		
		getProducts()
		.then((result) => {
			this.totalProducts = result;
			console.log('test');
			console.log(this.totalProducts);
			let tempProducts = []; 
			for (let key in this.totalProducts) {
				let maxPriceValue = 0;
				let maxProductValue = 0;
				
				for (let prod in this.totalProducts[key]) {
					console.log(this.totalProducts[key][prod].price);
					if(maxProductValue + 1 <= 100 && maxPriceValue + this.totalProducts[key][prod].price < 10000) {
						tempProducts.push(this.totalProducts[key][prod]);
						maxProductValue = maxProductValue + 1;
						maxPriceValue = maxPriceValue + this.totalProducts[key][prod].price;
					}
				}
			}

			this.products = tempProducts;
			if(this.products.length != 0) {
				this.emptyTable = false;
				
			}
			this.tableLoading =  false;
			

			const titles = new Set();
            const brands = new Set();
            const categories = new Set();

            for (let prod of this.products) {
                titles.add(prod.title);
                brands.add(prod.brand);
                categories.add(prod.category);
            }
			
            this.filterTitle = [...titles].map(title => ({ label: title, value: title }));
            this.filterBrand = [...brands].map(brand => ({ label: brand, value: brand }));
            this.filterCategory = [...categories].map(category => ({ label: category, value: category }));

			
		})
		.catch((error) => {
			console.log('In connected call back error....');
			console.log(error);
			this.error = error.body.message;
			this.errorCheck = true;
			console.log('Error is', this.error);
			this.tableLoading = false;
		});
		
	}

	handleFilterChange(event) {
		console.log('handleFilterChange');
		const field = event.target.name;
		const value = event.target.value;
		let tempList = [];
		if (field === 'category') {
			this.selectedCategory = value;
			for(let tempProd in this.products) {
				if(this.products[tempProd].category === value) {
					tempList.push(this.products[tempProd]);
				}
			}
		}
		else if (field === 'title') {
			this.selectedTitle = value;
			for(let tempProd in this.products) {
				if(this.products[tempProd].title === value) {
					tempList.push(this.products[tempProd]);
				}
			}
		}
		else if (field === 'brand') {
			this.selectedBrand = value;
			for(let tempProd in this.products) {
				if(this.products[tempProd].brand === value) {
					tempList.push(this.products[tempProd]);
				}
			}
		}
			
		
		console.log(tempList);
		const titles = new Set();
		const brands = new Set();
		const categories = new Set();

		for (let prod of tempList) {
			titles.add(prod.title);
			brands.add(prod.brand);
			categories.add(prod.category);
		}
		
		this.filterTitle = [...titles].map(title => ({ label: title, value: title }));
		this.filterBrand = [...brands].map(brand => ({ label: brand, value: brand }));
		this.filterCategory = [...categories].map(category => ({ label: category, value: category }));
		console.log(this.products);
		
		this.products = tempList;
		
		if(this.products.length != 0) {
			this.emptyTable = false;
			
		}
		else {
			this.emptyTable = true;
		}

		

	}

	handleRefresh() {
		console.log('refresh');
		this.resetVariables();
		this.connectedCallback();
	}

	resetVariables() {
	this.products = [];
	this.tableLoading = true;
	this.emptyTable = true;
	this.filterTitle = [];
	this.filterBrand = [];
	this.filterCategory = [];

	this.error = "";
	this.errorCheck = false;
	this.columns = columns;

	this.selectedTitle = "";
	this.selectedBrand = "";
	this.selectedCategory = "";
	}

	  
}