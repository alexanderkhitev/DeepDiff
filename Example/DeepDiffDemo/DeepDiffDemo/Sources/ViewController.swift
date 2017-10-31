import UIKit
import DeepDiff
import Anchors

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  var collectionView: UICollectionView!
  var items: [Int] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    title = "DeepDiff"

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 15)
    collectionView.backgroundColor = .lightGray

    view.addSubview(collectionView)
    activate(
      collectionView.anchor.edges
    )

    collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Reload", style: .plain, target: self, action: #selector(reload)
    )
  }

  @objc func reload() {
    let oldItems = items
    items = generateItems()
    let changes = diff(old: oldItems, new: items, reduceMove: true)
    collectionView.reload(changes: changes, completion: { _ in })
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
    let item = items[indexPath.item]

    cell.label.text = "\(item)"

    return cell
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let size = collectionView.frame.size.width / 5
    return CGSize(width: size, height: size)
  }

  // MARK: - Data

  func generateItems() -> [Int] {
    let count = Int(arc4random_uniform(10)) + 20
    let items = Array(0..<count)
    return items.shuffled()
  }
}
