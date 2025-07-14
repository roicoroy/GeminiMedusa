
import Foundation

class OrderConfirmationViewModel: ObservableObject {
    @Published var order: Order?

    func setOrder(order: Order) {
        self.order = order
    }
}
