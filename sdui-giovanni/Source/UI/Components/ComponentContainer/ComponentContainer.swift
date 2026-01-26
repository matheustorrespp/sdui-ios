//
//  ComponentContainer.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

class ComponentContainer: UIViewController {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let componentFactory: ComponentFactory = .init()
    
    private var components: [ComponentView] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - UI
    
    lazy var container: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var containerBottomConstraint: NSLayoutConstraint = {
        container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }()
    
    // MARK: - INITIALIZERS
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIKIT LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveComponents()
    }
    
    // MARK: - LIFE CYCLE
    
    func execute(action: ActionType, from component: ComponentView) {
        // SHOULD BE OVERRIDEN
    }
    
    func retrieveComponents() {
        // SHOULD BE OVERRIDEN
    }
    
    // MARK: - PUBLIC METHODS
    
    func updateComponents(_ components: [[String: AnyCodable]]) {
        self.components = components.compactMap { [weak self] in
            self?.componentFactory.makeComponent(component: $0)
        }
    }
    
    func componentsView() -> [ComponentView] {
        components
    }
    
    func updateUI(force: Bool = false) {
        if force {
            reloadData()
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            UIView.removeAnimations {
                self.container.beginUpdates()
                self.container.endUpdates()
            }
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupView() {
        createViewHierarchy()
        constrainUI()
    }
    
    private func createViewHierarchy() {
        view.addSubview(container)
    }
    
    private func constrainUI() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerBottomConstraint
        ])
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.container.reloadData()
        }
    }
    
    private func executeDefault(action: ActionType, from component: ComponentView) {
        switch action {
//        case .tracking:
//            dependencies.thundera
        default:
            execute(action: action, from: component)
        }
    }
}

// MARK: - ComponentViewDelegate

extension ComponentContainer: ComponentViewDelegate {
    func didSelect(_ component: any ComponentView, with action: ActionType) {
        executeDefault(action: action, from: component)
    }
    
    func componentContainer() -> ComponentContainer? {
        self
    }
}

// MARK: - UITableViewDataSource

extension ComponentContainer: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeueReusableCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifier, for: indexPath)
        guard let customCell = dequeueReusableCell as? CustomCell,
              let componentView = components[safe: indexPath.row] else {
            return .init()
        }
        componentView.delegate = self
        customCell.setup(view: componentView)
        return customCell
    }
}

// MARK: - UITableViewDelegate

extension ComponentContainer: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
