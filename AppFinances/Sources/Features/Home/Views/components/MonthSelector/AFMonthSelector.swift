//
//  HomerHeaderView.swift
//  AppFinances
//
//  Created by Edgar on 30/06/25.
//

import UIKit
import Combine

class AFMonthSelector: UIView {
    
    private var months: [AFMonthYear] = []
    
    private var centeredIndexPath: IndexPath? = nil
    
    let monthYearPublisher = PassthroughSubject<AFMonthYear, Never>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = AFMonthSelector.makeCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        collectionView.allowsSelection = true
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .clear
        
        collectionView.register(MonthSelectViewCell.self, forCellWithReuseIdentifier: MonthSelectViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(.afChevronLeft, for: .normal)
        button.imageView?.tintColor = .afGray500
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(.afChevronLeft, for: .normal)
        button.imageView?.tintColor = .afGray500
        button.imageView?.contentMode = .scaleAspectFit
        button.transform = .init(rotationAngle: .pi)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        translatesAutoresizingMaskIntoConstraints = false
        generateInitialMonths()
        setupHierarchy()
        setupConstraints()
    }

    private func setupHierarchy(){
        addSubview(previousButton)
        addSubview(collectionView)
        addSubview(nextButton)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            previousButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            previousButton.leftAnchor.constraint(equalTo: leftAnchor,constant: 5),
            previousButton.widthAnchor.constraint(equalToConstant: 18),
            previousButton.heightAnchor.constraint(equalTo: heightAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor,constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor,constant: -12),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            nextButton.widthAnchor.constraint(equalToConstant: 18),
            nextButton.heightAnchor.constraint(equalTo: heightAnchor),
        ])
        
        previousButton.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    func setMonthYear(_ monthYear: AFMonthYear){
        guard let index = months.firstIndex(of: monthYear) else {
            return
        }
        
        let newCenteredIndex = IndexPath(row: index, section: 0)
        self.centeredIndexPath = newCenteredIndex
        collectionView.scrollToItem(at: newCenteredIndex, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.centerVisibleMonth(ignoringPublisher: true)
        }
    }
    
    private func setCenteredIndexPath(_ indexPath: IndexPath){
        centeredIndexPath = indexPath
        monthYearPublisher.send(months[indexPath.item])
    }
    
    @objc
    private func didTapPrevious(){
        guard let currentIndex = centeredIndexPath?.item else {
            return
        }

        let targetIndex = currentIndex - 12
        var adjustedIndex = targetIndex

        if targetIndex < 6 {
            let previousCount = months.count
            prependMonths()
            let addedCount = months.count - previousCount
            adjustedIndex += addedCount
        }

        let centeredIndexPath = IndexPath(item: adjustedIndex, section: 0)
        
        collectionView.scrollToItem(at: centeredIndexPath, at: .centeredHorizontally, animated: true)

        setCenteredIndexPath(centeredIndexPath)
    }
    
    @objc
    private func didTapNext(){
        guard let currentIndex = centeredIndexPath?.item else {
            return
        }
        let nextIndex = currentIndex + 12
        
        if nextIndex > months.count - 6 {
            appendMonths()
        }
        
        let centeredIndexPath = IndexPath(item: nextIndex, section: 0)
        
        collectionView.scrollToItem(at: centeredIndexPath, at: .centeredHorizontally, animated: true)
         
        setCenteredIndexPath(centeredIndexPath)
    }
    
    private func centerVisibleMonth(ignoringPublisher: Bool = false){
        let center = collectionView.convert(center, from: self)
        
        if let indexPath = collectionView.indexPathForItem(at: center) {
            collectionView.reloadData()
            
            if !ignoringPublisher {
                setCenteredIndexPath(indexPath)
            }
            
            if indexPath.item < 6 {
                prependMonths()
            }
            
            if indexPath.item > months.count - 6 {
                appendMonths()
            }
        }
    }
    
    private func generateInitialMonths(){
        let calendar = Calendar.current
        
        let startDate = calendar.date(byAdding: .month, value: -24, to: Date())
        
        guard let startDate else {
            return
        }
        
        for i in 0...48 {
            guard let date = calendar.date(byAdding: .month, value: i, to: startDate) else {
                continue
            }
            
            months.append(AFMonthYear.from(date: date))
        }
    }
    
    private func prependMonths(){
        guard
            let firstMonth = months.first,
            let firstDate = firstMonth.date,
            let initialDate = Calendar.current.date(byAdding: .month, value: -13, to: firstDate)
        else {
            return
        }
        
        let newMonths = generateYear(from: initialDate)
        
        months.insert(contentsOf: newMonths, at: 0)
        
        if let currentIndex = centeredIndexPath?.item {
            let centeredIndexPath = IndexPath(item: newMonths.count + currentIndex, section: 0)
            setCenteredIndexPath(centeredIndexPath)
            collectionView.scrollToItem(
                at: centeredIndexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
    
    private func appendMonths(){
        guard
            let lastMonth = months.last,
            let lastDate = lastMonth.date,
            let startingDate = Calendar.current.date(byAdding: .month, value: 1, to: lastDate)
        else {
            return
        }
        
        let newMonths = generateYear(from: startingDate)
        
        months.append(contentsOf: newMonths)
        
        collectionView.reloadData()
    }
    
    func centerToCurrentDate(){
        let monthYear = AFMonthYear.from(date: Date())
        
        guard
            let monthYearIndex = months.firstIndex(where:{ $0 == monthYear })
        else {
            return
        }
        
        let indexPath = IndexPath(item: monthYearIndex, section: 0)
        
        setCenteredIndexPath(indexPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func generateYear(from initialDate:Date) -> [AFMonthYear] {
        var newMonths: [AFMonthYear] = []
        
        for i in 0...12 {
            if let date = Calendar.current.date(byAdding: .month, value: i, to: initialDate) {
                newMonths.append(.from(date: date))
            }
        }
        
        return newMonths
    }
    
    private static func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = SnappingCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 67, height: 58)
        layout.minimumLineSpacing = 0
        
        return layout
    }
    
}


extension AFMonthSelector: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MonthSelectViewCell.identifier, for: indexPath
            ) as? MonthSelectViewCell
        else {
            return UICollectionViewCell()
        }
        
        let monthYear = months[indexPath.item]
        let isCentered = indexPath == centeredIndexPath
        
        cell.configure(with: monthYear, isCentered: isCentered)
        
        return cell
    }
        
}

extension AFMonthSelector: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerVisibleMonth()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerVisibleMonth()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let monthYear = months[indexPath.row]
        setMonthYear(monthYear)
        monthYearPublisher.send(monthYear)
    }
    
}
