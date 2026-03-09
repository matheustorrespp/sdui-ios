import UIKit

/// Orquestra a navegação por deeplink a partir de qualquer ponto do app.
///
/// Uso:
/// ```swift
/// DeeplinkNavigator.shared.navigate(to: "/detail?title=torres")
/// ```
///
final class DeeplinkNavigator {

    static let shared = DeeplinkNavigator()

    // MARK: - PRIVATE PROPERTIES

    private weak var navigationController: UINavigationController?

    private init() {}

    // MARK: - SETUP

    /// Deve ser chamado uma vez no AppDelegate para registrar o nav controller root.
    func setup(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - PUBLIC METHODS

    /// Navega para uma rota a partir de uma string de deeplink.
    ///
    /// - Parameter rawRoute: ex: `/detail?title=torres`, `sdui://detail?title=torres`
    /// - Parameter animated: animar a transição (default `true`)
    ///
    func navigate(to rawRoute: String, animated: Bool = true) {
        let route = DeeplinkRoute.from(rawRoute)
        navigate(to: route, animated: animated)
    }

    /// Navega para uma `DeeplinkRoute` já parseada.
    func navigate(to route: DeeplinkRoute, animated: Bool = true) {
        guard let viewController = DeeplinkRouter.resolve(route: route) else { return }

        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
}
