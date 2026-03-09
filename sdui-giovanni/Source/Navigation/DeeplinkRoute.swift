import Foundation

/// Rotas conhecidas do app. Cada case mapeia um path de deeplink.
///
/// Exemplos:
///   - `/detail?imageName=imagem&title=torres&text=descricao`  →  `.detail(imageName:title:text:)`
///   - `/home`                                                  →  `.home`
///
enum DeeplinkRoute {
    case home
    case detail(imageName: String, title: String, text: String)
    case unknown

    // MARK: - FACTORY

    /// Parseia uma string de rota (pode ser URL completa ou só path + query).
    ///
    /// Aceita formatos:
    ///   - `sdui://detail?title=torres`
    ///   - `/detail?title=torres`
    ///   - `detail?title=torres`
    ///
    static func from(_ rawRoute: String) -> DeeplinkRoute {
        // Normaliza: se não tiver scheme, adiciona um placeholder para o URLComponents funcionar
        let normalized: String
        if rawRoute.contains("://") {
            normalized = rawRoute
        } else {
            let cleaned = rawRoute.hasPrefix("/") ? rawRoute : "/\(rawRoute)"
            normalized = "app://host\(cleaned)"
        }

        guard let components = URLComponents(string: normalized) else { return .unknown }

        let path = components.path
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()

        let params = Self.queryParams(from: components)

        switch path {
        case "", "home":
            return .home
        case "detail":
            let imageName = params["imagename"] ?? ""
            let title = params["title"] ?? ""
            let text = params["text"] ?? ""
            return .detail(imageName: imageName, title: title, text: text)
        default:
            return .unknown
        }
    }

    // MARK: - HELPERS

    private static func queryParams(from components: URLComponents) -> [String: String] {
        var dict: [String: String] = [:]
        components.queryItems?.forEach { item in
            dict[item.name.lowercased()] = item.value
        }
        return dict
    }
}
