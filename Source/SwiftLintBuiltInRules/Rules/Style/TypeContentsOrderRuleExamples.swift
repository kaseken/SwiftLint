internal struct TypeContentsOrderRuleExamples {
    static let defaultOrderParts = [
            """
            // Type Aliases
            typealias CompletionHandler = ((TestEnum) -> Void)
            """,
            """
            // Subtypes
            class TestClass {
                // 10 lines
            }

            struct TestStruct {
                // 3 lines
            }

            enum TestEnum {
                // 5 lines
            }
            """,
            """
            // Type Properties
            static let cellIdentifier: String = "AmazingCell"
            """,
            """
            // Instance Properties
            var shouldLayoutView1: Bool!
            weak var delegate: TestViewControllerDelegate?
            private var hasLayoutedView1: Bool = false
            private var hasLayoutedView2: Bool = false

            private var hasAnyLayoutedView: Bool {
                 return hasLayoutedView1 || hasLayoutedView2
            }
            """,
            """
            // IBOutlets
            @IBOutlet private var view1: UIView!
            @IBOutlet private var view2: UIView!
            """,
            """
            // Initializers
            override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
                super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            }

            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            """,
            """
            // Type Methods
            static func makeViewController() -> TestViewController {
                // some code
            }
            """,
            """
            // View Life-Cycle Methods
            override func viewDidLoad() {
                super.viewDidLoad()

                view1.setNeedsLayout()
                view1.layoutIfNeeded()
                hasLayoutedView1 = true
            }

            override func willMove(toParent parent: UIViewController?) {
                super.willMove(toParent: parent)
                if parent == nil {
                    viewModel.willMoveToParent()
                }
            }

            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()

                view2.setNeedsLayout()
                view2.layoutIfNeeded()
                hasLayoutedView2 = true
            }

            override func viewIsAppearing(_ animated: Bool) {
                super.viewIsAppearing(animated)
            }
            """,
            """
            // IBActions
            @IBAction func goNextButtonPressed() {
                goToNextVc()
                delegate?.didPressTrackedButton()
            }
            """,
            """
            // Other Methods
            func goToNextVc() { /* TODO */ }

            func goToInfoVc() { /* TODO */ }

            func goToRandomVc() {
                let viewCtrl = getRandomVc()
                present(viewCtrl, animated: true)
            }

            private func getRandomVc() -> UIViewController { return UIViewController() }
            """,
            """
            // Subscripts
            subscript(_ someIndexThatIsNotEvenUsed: Int) -> String {
                get {
                    return "This is just a test"
                }

                set {
                    log.warning("Just a test", newValue)
                }
            }
            """,
            """
            deinit {
                log.debug("deinit")
            }
            """,
    ]

    static let nonTriggeringExamples = [
        Example("""
        class TestViewController: UIViewController {
        \(Self.defaultOrderParts.joined(separator: "\n\n")),
        }
        """),
        Example("""
        struct ContentView: View {
            @available(SwiftUI_v5, *) // Availability macro syntax: https://github.com/swiftlang/swift/pull/65218
            var v5Body: some View { EmptyView() }
            var body: some View { EmptyView() }
        }
        """),
    ]

    static let triggeringExamples = [
        Example("""
        class TestViewController: UIViewController {
            // Subtypes
            ↓class TestClass {
                // 10 lines
            }

            // Type Aliases
            typealias CompletionHandler = ((TestEnum) -> Void)
        }
        """),
        Example("""
        class TestViewController: UIViewController {
            // Stored Type Properties
            ↓static let cellIdentifier: String = "AmazingCell"

            // Subtypes
            class TestClass {
                // 10 lines
            }
        }
        """),
        Example("""
        class TestViewController: UIViewController {
            // Stored Instance Properties
            ↓var shouldLayoutView1: Bool!

            // Stored Type Properties
            static let cellIdentifier: String = "AmazingCell"
        }
        """),
        Example("""
        class TestViewController: UIViewController {
            // IBOutlets
            @IBOutlet private ↓var view1: UIView!

            // Computed Instance Properties
            private var hasAnyLayoutedView: Bool {
                 return hasLayoutedView1 || hasLayoutedView2
            }
        }
        """),
        Example("""
        class TestViewController: UIViewController {

            // deinitializer
            ↓deinit {
                log.debug("deinit")
            }

            // Initializers
            override ↓init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
                super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            }

            // IBOutlets
            @IBOutlet private var view1: UIView!
            @IBOutlet private var view2: UIView!
        }
        """),
        Example("""
        class TestViewController: UIViewController {
            // View Life-Cycle Methods
            override ↓func viewDidLoad() {
                super.viewDidLoad()

                view1.setNeedsLayout()
                view1.layoutIfNeeded()
                hasLayoutedView1 = true
            }

            // Type Methods
            static func makeViewController() -> TestViewController {
                // some code
            }
        }
        """),
        Example("""
        class TestViewController: UIViewController {
            // IBActions
            @IBAction ↓func goNextButtonPressed() {
                goToNextVc()
                delegate?.didPressTrackedButton()
            }

            // View Life-Cycle Methods
            override func viewDidLoad() {
                super.viewDidLoad()

                view1.setNeedsLayout()
                view1.layoutIfNeeded()
                hasLayoutedView1 = true
            }
        }
        """),
        Example("""
        class TestViewController: UIViewController {
            // Other Methods
            ↓func goToNextVc() { /* TODO */ }

            // IBActions
            @IBAction func goNextButtonPressed() {
                goToNextVc()
                delegate?.didPressTrackedButton()
            }
        }
        """),
        Example("""
        class TestViewController: UIViewController {
            // Subscripts
            ↓subscript(_ someIndexThatIsNotEvenUsed: Int) -> String {
                get {
                    return "This is just a test"
                }

                set {
                    log.warning("Just a test", newValue)
                }
            }

            // MARK: Other Methods
            func goToNextVc() { /* TODO */ }
        }
        """),
        Example("""
        protocol P {
            ↓var x: U { get }
            @available(*, unavailable)
            ↓associatedtype T
            typealias U = Int
        }
        """, configuration: ["order": [["type_alias"], ["associated_type"]]], excludeFromDocumentation: true),
        Example("""
        enum E {
            @available(*, unavailable)
            ↓case a
            func f() {}
        }
        """, configuration: ["order": [["other_method"], ["case"]]], excludeFromDocumentation: true),
        Example("""
        final class C {
            ↓var i = 1
            static var I = 2
            class var s: Int {
                struct S {}
                return 3
            }
        }
        """),
        Example("""
        final class C {
            ↓var i = 1
            #if os(macOS)
            static var I = 2
            #endif
        }
        """),
        Example("""
        struct S {
            ↓var i = 1
            #if os(macOS)
                #if swift(>=5.3)
                ↓func f() {}
                #endif
            #else
                static var i = 3
            #endif
        }
        """),
    ]
}
