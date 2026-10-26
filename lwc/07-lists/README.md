# 07 · Lists

The code for **LWC from Zero #7**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`productList`**, placed under `customerStatus` on the **Customer Desk** tab: two product lists built from one array of four Sharma Traders products. The first list uses `for:each` and `for:item` to show every product; the second uses a getter (`filter` and `map`) plus `iterator:it` so the first in-stock item is marked `Best seller:` and the last says `(last on the list)`.

The key idea: **`for:each` repeats a part for every item, and every item needs its own `key`.**

**`force-app/main/default/lwc/productList/productList.html`**:

```html
<template>
    <p>All products</p>
    <ul>
        <template for:each={products} for:item="product">
            <li key={product.id}>{product.name}: ₹{product.price}</li>
        </template>
    </ul>
    <p>In stock today</p>
    <ul>
        <template iterator:it={inStockProducts}>
            <li key={it.value.id}>
                <template lwc:if={it.first}>Best seller: </template>
                {it.value.label}
                <template lwc:if={it.last}> (last on the list)</template>
            </li>
        </template>
    </ul>
</template>
```

**`productList.js`**:

```js
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
```

**`productList.js-meta.xml`**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>68.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__AppPage</target>
    </targets>
</LightningComponentBundle>
```

The project also includes `customerCard`, `customerGreeting`, `customerName` and `customerStatus` from videos 3–6.

## Deploy it and add it to the page

1. Deploy `force-app` from VS Code (`SFDX: Deploy This Source to Org`) or the terminal:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab in your org, click the gear in the top right and choose **Edit Page**.
3. Under **Custom (5)** on the left, drag `productList` below `customerStatus`.
4. Click **Save**, then click the back arrow in the top left.

## What you should see

Scroll down to `productList` on the **Customer Desk** tab:

```
All products
Packing tape: ₹120
Cardboard boxes: ₹450
Bubble wrap: ₹300
LED bulbs: ₹99
In stock today
Best seller: Packing tape: ₹120
Cardboard boxes: ₹450
LED bulbs: ₹99 (last on the list)
```

Notice there are no bullet points: Salesforce's styles reset `<ul>` lists just as they reset `<h1>` headings in video 3. Video 8 styles the whole desk with Salesforce cards and badges.

**Your small task:** add a fifth product to `products` — `Gift wrap`, `60` rupees, `inStock: false` — then deploy and check which of the two lists it appears in. This folder doesn't include that fifth product, so you can try it yourself.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
