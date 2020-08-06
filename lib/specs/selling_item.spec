Specification Heading
=====================
Created by RICHARD MURAGIJIMANA on 21/03/2020

This is an executable specification file which follows markdown syntax.
Every heading in this file denotes a scenario. Every bulleted point denotes a step.
     
SELLING ITEM
----------------
* Click on item from a list ofproducts
    *A temporal order should be in place to be used on this current sale order
* Go to the changeQuantity selling page
    *modify variant quantity to sell per cart
* Add to cart button should add item to current cartItem List
* on completion of selling item from cart should create a new temp order.

*TODO(richard): what happen if I sell this custom product
    *then on create of new product start by editing this custom product:
    *the problem: we can loose control of which has been sold for that purpose.
    *solution 1: we keep the name custom for the flow of the product creation
    *         2: we name a custom selling on POS to custom-product
    *         3: we keep refering custom-product as an item sold without stock or actual flow,just sell of fly
    *         4: ensure this custom-product is loaded when app start.