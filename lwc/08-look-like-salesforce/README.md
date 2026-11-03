# 08 · Make It Look Like Salesforce

The code for **LWC from Zero #8**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

You styled the existing **Customer Desk** components (`customerCard`, `customerGreeting`, `customerName`, `customerStatus` and `productList`) using three tools in order:
1. **`lightning-card`** (`title` and `icon-name`) so each component sits in a real Salesforce card.
2. **SLDS utility classes** (`slds-p-horizontal_small`, `slds-m-top_small`, `slds-m-bottom_small`, `slds-m-vertical_small`, `slds-m-right_x-small`, `slds-text-heading_medium`, `slds-text-title_caps`) for spacing and typography.
3. **Component `.css` files and SLDS styling hooks** (`:host { --slds-c-card-color-background: #fff8ee; }`, `.company`, `.price`, and `.badge`) for your own elements and card overrides.

The key idea: **style with base components and SLDS classes first; write `.css` only for your own tags, and use styling hooks (`--slds-c-...`) inside `:host` when changing a base component's look.**

**`force-app/main/default/lwc/customerCard/customerCard.html`**:

```html
<template>
    <lightning-card title="Ravi Sharma" icon-name="standard:contact">
        <p class="company slds-p-horizontal_small">Sharma Traders, Greater Noida</p>
    </lightning-card>
</template>
```

**`force-app/main/default/lwc/customerCard/customerCard.css`**:

```css
:host {
    --slds-c-card-color-background: #fff8ee;
}

.company {
    font-weight: bold;
}
```

**`force-app/main/default/lwc/productList/productList.html`**:

```html
<template>
    <lightning-card title="Products" icon-name="standard:product">
        <div class="slds-p-horizontal_small">
            <p class="slds-text-title_caps">All products</p>
            <ul class="slds-m-bottom_small">
                <template for:each={products} for:item="product">
                    <li key={product.id}>{product.name}: <span class="price">₹{product.price}</span></li>
                </template>
            </ul>
            <p class="slds-text-title_caps">In stock today</p>
            <ul>
                <template iterator:it={inStockProducts}>
                    <li key={it.value.id}>
                        <template lwc:if={it.first}><span class="badge slds-m-right_x-small">Best seller</span></template>
                        {it.value.label}
                        <template lwc:if={it.last}> (last on the list)</template>
                    </li>
                </template>
            </ul>
        </div>
    </lightning-card>
</template>
```

**`force-app/main/default/lwc/productList/productList.css`**:

```css
.price {
    font-weight: bold;
}

.badge {
    background: #2e844a;
    color: white;
    border-radius: 4px;
    padding: 0 4px;
}
```

`customerGreeting`, `customerName` and `customerStatus` are also wrapped in `<lightning-card>` with `slds-p-horizontal_small` padding.

## Deploy it

Deploy `force-app` from VS Code (`SFDX: Deploy This Source to Org`) or the terminal:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```

Refresh the **Customer Desk** tab in your org. All five components are already on the page from videos 3–7.

## What you should see

- **`customerCard`** at the top in a warm cream card (`#fff8ee`) with the `standard:contact` icon, title `Ravi Sharma`, and bold `Sharma Traders, Greater Noida`.
- **`customerGreeting`**, **`customerName`**, **`customerStatus`** and **`productList`** each inside its own white Salesforce card with an icon, clean horizontal padding, uppercase section labels (`ALL PRODUCTS`, `IN STOCK TODAY`), bold prices (`₹120`), and a green `Best seller` pill next to `Packing tape: ₹120`.

**Your small task:** add a `.top` class in `customerStatus.css` (`color: #2e844a; font-weight: bold;`) and put `class="top"` on the `Top customer` paragraph in `customerStatus.html`, then deploy and enter `6` in `Orders this year`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
