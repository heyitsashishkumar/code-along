import { LightningElement } from 'lwc';

export default class ProductList extends LightningElement {
    products = [
        { id: 'p1', name: 'Packing tape', price: 120, inStock: true },
        { id: 'p2', name: 'Cardboard boxes', price: 450, inStock: true },
        { id: 'p3', name: 'Bubble wrap', price: 300, inStock: false },
        { id: 'p4', name: 'LED bulbs', price: 99, inStock: true }
    ];

    get inStockProducts() {
        return this.products
            .filter((product) => product.inStock)
            .map((product) => ({
                id: product.id,
                label: `${product.name}: ₹${product.price}`
            }));
    }
}
