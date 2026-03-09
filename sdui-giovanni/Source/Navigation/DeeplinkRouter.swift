import UIKit

/// Responsável por resolver uma `DeeplinkRoute` em um `UIViewController` concreto.
///
/// Uso:
/// ```swift
/// let vc = DeeplinkRouter.resolve(route: .detail(imageName: "imagem", title: "torres", text: "descricao"))
/// ```
///
enum DeeplinkRouter {

    static func resolve(route: DeeplinkRoute) -> UIViewController? {
        switch route {
        case .home:
            return HomeViewController()

        case .detail(let imageName, let title, let text):
            let model = DetailViewController.ViewModel(
                imageName: imageName,
                title: title,
                text: text
            )
            return DetailViewController(model: model)

        case .unknown:
            return nil
        }
    }
}
