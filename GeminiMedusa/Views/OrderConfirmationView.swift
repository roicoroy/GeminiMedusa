
import SwiftUI

struct OrderConfirmationView: View {
    @ObservedObject var viewModel: OrderConfirmationViewModel

    var body: some View {
        VStack {
            if let order = viewModel.order {
                Text("Order Confirmation")
                    .font(.largeTitle)
                    .padding()

                Text("Thank you for your order, \(order.email ?? "customer")!")
                    .padding()

                List(order.items ?? [], id: \.id) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text("Quantity: \(item.quantity)")
                        }
                        Spacer()
                        Text(item.formattedTotal(currencyCode: order.currencyCode))
                    }
                }

                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Subtotal: \(order.formattedSubtotal)")
                    Text("Shipping: \(order.formattedShippingTotal)")
                    Text("Tax: \(order.formattedTaxTotal)")
                    Text("Total: \(order.formattedTotal)")
                        .font(.headline)
                }
                .padding()

            } else {
                Text("Loading order details...")
            }
        }
        .navigationTitle("Order Confirmation")
    }
}

//struct OrderConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = OrderConfirmationViewModel()
//        let mockOrder = Order(
//            id: "order_123",
//            regionId: "reg_123",
//            customerId: "cus_123",
//            salesChannelId: "sc_123",
//            email: "customer@example.com",
//            currencyCode: "usd",
//            items: [
//                OrderLineItem(
//                    id: "item_1",
//                    title: "Medusa Coffee Mug",
//                    subtitle: nil,
//                    thumbnail: nil,
//                    variantId: "variant_1",
//                    productId: "prod_1",
//                    productTitle: "Medusa Coffee Mug",
//                    productDescription: "A nice coffee mug.",
//                    productSubtitle: nil,
//                    productType: "Mug",
//                    productCollection: "Mugs",
//                    productHandle: "medusa-coffee-mug",
//                    variantSku: "MUG-01",
//                    variantBarcode: nil,
//                    variantTitle: "Default",
//                    variantOptionValues: nil,
//                    requiresShipping: true,
//                    isDiscountable: true,
//                    isTaxInclusive: false,
//                    unitPrice: 1200,
//                    quantity: 1,
//                    detail: nil,
//                    createdAt: nil,
//                    updatedAt: nil,
//                    metadata: nil,
//                    originalTotal: 1200,
//                    originalSubtotal: 1200,
//                    originalTaxTotal: 0,
//                    itemTotal: 1200,
//                    itemSubtotal: 1200,
//                    itemTaxTotal: 0,
//                    total: 1200,
//                    subtotal: 1200,
//                    taxTotal: 0,
//                    discountTotal: 0,
//                    discountTaxTotal: 0,
//                    refundableTotal: 1200,
//                    refundableTotalPerUnit: 1200,
//                    productTypeId: nil
//                )
//            ],
//            shippingMethods: nil,
//            paymentStatus: "paid",
//            fulfillmentStatus: "not_fulfilled",
//            summary: nil,
//            createdAt: nil,
//            updatedAt: nil,
//            originalItemTotal: 1200,
//            originalItemSubtotal: 1200,
//            originalItemTaxTotal: 0,
//            itemTotal: 1200,
//            itemSubtotal: 1200,
//            itemTaxTotal: 0,
//            originalTotal: 1300,
//            originalSubtotal: 1200,
//            originalTaxTotal: 100,
//            total: 1300,
//            subtotal: 1200,
//            taxTotal: 100,
//            discountTotal: 0,
//            discountTaxTotal: 0,
//            giftCardTotal: 0,
//            giftCardTaxTotal: 0,
//            shippingTotal: 100,
//            shippingSubtotal: 100,
//            shippingTaxTotal: 0,
//            originalShippingTotal: 100,
//            originalShippingSubtotal: 100,
//            originalShippingTaxTotal: 0,
//            status: "completed",
//            creditLineTotal: nil
//        )
//        viewModel.setOrder(order: mockOrder)
//        return OrderConfirmationView(viewModel: viewModel)
//    }
//}
