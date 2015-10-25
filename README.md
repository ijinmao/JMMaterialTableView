JMMaterialTableView ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)
=======================

![Version](http://cocoapod-badges.herokuapp.com/v/JMMaterialTableView/badge.png)
![Platform](http://cocoapod-badges.herokuapp.com/p/JMMaterialTableView/badge.png)

Overview
---
`JMMaterialTableView` is a tableView inspired by [Primer](http://www.yourprimer.com/) iOS app in Swift.

The UX of Primer iOS app is amazing, and Google's Primer team wrote a great [article](https://medium.com/google-design/designing-a-ux-for-learning-ebed4fa0a798#.2ee2djini) about how they approached UX.

The cell transformation part is modified from [StickyCollectionView](https://github.com/matbeich/StickyCollectionView).

Video
---
The demo in this project looks like this:

![screenshot1](https://raw.githubusercontent.com/ijinmao/JMMaterialTableView/master/demoScreen1.gif)


You can build a card table view like this:

![screenshot1](https://raw.githubusercontent.com/ijinmao/JMMaterialTableView/master/demoScreen2.gif)

Installation
---
Add this to your Podfile to use JMMaterialTableView:

	pod 'JMMaterialTableView', '~> 0.1.1'

Alternatively you can directly add the JMMaterialLayout.swift and JMMaterialTableView.swift to your project.

Usage
---
Notice that `JMMaterialTableView` is actually an `UICollectionView`. After initialization, you can use it as a normal `UICollectionView`.

Initialize `JMMaterialLayout` and `JMMaterialTableView` in your viewController:

```Swift
	let layout = JMMaterialLayout()
	let tableView = JMMaterialTableView(frame: frame, collectionViewLayout: layout) 
```

Set the cell size:

```Swift
	tableView.cellSize = CGSizeMake(cellWidth, cellHeight)
```

Then you can use `JMMaterialTableView` just as a normal `UICollectionView`.

Restriction
---
`JMMaterialTableView` is not supported **dynamic** cell height yet. 

I don't recommend dynamic cell height tableView to use this actually, the UX is not pretty I think.

Demo
---
You can **customize** collectionView and cell by modifying `JMMaterialCell.swift` and `TableViewDataSource.swift` in the demo.

Configuration
---
You can **customize** following properties in `JMMaterialTableView.swift` to change the default view:

* cellSize
* isTransformEnabled   		when set false, the cell size will not reduce after scrolling
* enableAutoScroll			when set true, the tableView will always scroll to a cell top position
* enableCellShadow		
* scrollDecelerationRate 		
* shadowOffset			
* shadowRadius
* shadowOpacity
* shadowColor
* transformCoef

