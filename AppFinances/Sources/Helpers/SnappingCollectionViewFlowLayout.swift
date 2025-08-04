//
//  SnappingCollectionViewFlowLayout.swift
//  AppFinances
//
//  Created by Edgar on 04/07/25.
//


import Foundation
import UIKit

class SnappingCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
           guard let collectionView = collectionView else {
               return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
           }

           let collectionViewSize = collectionView.bounds.size
           let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2

           let targetRect = CGRect(
               x: proposedContentOffset.x,
               y: 0,
               width: collectionViewSize.width,
               height: collectionViewSize.height
           )

           guard let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect) else {
               return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
           }

           var closestAttributes: UICollectionViewLayoutAttributes?
           var minDistance = CGFloat.greatestFiniteMagnitude

           for attributes in layoutAttributesArray {
               let itemCenterX = attributes.center.x
               let distance = abs(itemCenterX - proposedContentOffsetCenterX)
               if distance < minDistance {
                   minDistance = distance
                   closestAttributes = attributes
               }
           }

           guard let closest = closestAttributes else {
               return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
           }

           let adjustedOffsetX = closest.center.x - collectionViewSize.width / 2

           return CGPoint(x: adjustedOffsetX, y: proposedContentOffset.y)
       }
}
