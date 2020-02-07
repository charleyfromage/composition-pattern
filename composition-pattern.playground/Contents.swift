import UIKit

struct DataSource {
    func bind(to view: UIView) {

    }
}

/// View model
protocol NavigationBarViewModel {
    var navigationBarTitle: String { get set }
}

protocol TableViewModel {
    var dataSource: DataSource? { get set }
}

class MyViewModel: NavigationBarViewModel, TableViewModel {
    var navigationBarTitle: String = "This is my navbar title"
    var dataSource: DataSource?
}

/// View controller
protocol VC: UIViewController {
    associatedtype ViewModel

    var viewModel: ViewModel? { get set }
}

protocol VCWithNavigationBar: VC {
    func bindNavigationBar()
}

extension VC where Self: VCWithNavigationBar , Self.ViewModel: NavigationBarViewModel {
    func bindNavigationBar() {
        title = viewModel?.navigationBarTitle
    }
}

protocol VCWithTableView: UIViewController {
    var tableView: UITableView! { get }

    func bindTableView()
}

extension VC where Self: VCWithTableView , Self.ViewModel: TableViewModel {
    func bindTableView() {
        viewModel?.dataSource?.bind(to: tableView)
    }
}

class MyViewController<ViewModel: NavigationBarViewModel & TableViewModel>: UIViewController, VC, VCWithNavigationBar, VCWithTableView {
    @IBOutlet internal weak var tableView: UITableView!

    var viewModel: ViewModel? {
        didSet {
            setupBindings()
        }
    }

    private func setupBindings() {
        bindNavigationBar()
        bindTableView()
    }
}

/// Testing
let vc = MyViewController<MyViewModel>()
let vm = MyViewModel()
vc.viewModel = vm

print(vc.title)
