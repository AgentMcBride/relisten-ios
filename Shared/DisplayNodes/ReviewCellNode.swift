//
//  ReviewCellNode.swift
//  Relisten
//
//  Created by Alec Gorge on 5/31/18.
//  Copyright © 2018 Alec Gorge. All rights reserved.
//

import UIKit

import AsyncDisplayKit

public class ReviewCellNode: ASCellNode {
    public static var dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateStyle = .long
        
        return d
    }()
    
    public init(review: SourceReview, forArtist artist: Artist) {
        if artist.features.review_titles, let reviewTitle = review.title {
            self.titleNode = ASTextNode(reviewTitle, textStyle: .headline, weight: .Bold)
        } else {
            self.titleNode = nil
        }
        
        if let reviewAuthor = review.author {
            let scale : CGFloat = artist.features.review_titles ? 0.8 : 1.0
            self.authorNode = ASTextNode(reviewAuthor, textStyle: .body, scale: scale, weight: .Bold)
        } else {
            self.authorNode = nil
        }
        
        self.dateNode = ASTextNode(ReviewCellNode.dateFormatter.string(from: review.updated_at), textStyle: .caption1)
        
        if artist.features.reviews_have_ratings, let userRating = review.rating {
            self.ratingNode = AXRatingViewNode(value: Float(userRating) / 10.0)
        } else {
            self.ratingNode = nil
        }
        
        self.review = ASTextNode(review.review, textStyle: .body)
        
        super.init()
        
        automaticallyManagesSubnodes = true
        accessoryType = .none
    }
    
    let titleNode : ASTextNode?
    let authorNode : ASTextNode?
    let dateNode : ASTextNode
    let ratingNode : AXRatingViewNode?
    let review : ASTextNode
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let authorAndDateStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .start,
            alignItems: .start,
            children: ArrayNoNils(
                authorNode,
                dateNode
            )
        )
        authorAndDateStack.style.alignSelf = .stretch
        
        let authorAndRatingStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 4,
            justifyContent: .start,
            alignItems: .center,
            children: ArrayNoNils(
                authorAndDateStack,
                SpacerNode(),
                ratingNode
            )
        )
        authorAndRatingStack.style.alignSelf = .stretch
        
        let reviewStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 8,
            justifyContent: .start,
            alignItems: .start,
            children: ArrayNoNils(
                titleNode,
                authorAndRatingStack,
                review
            )
        )
        reviewStack.style.alignSelf = .stretch
        
        let l = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
            child: reviewStack
        )
        l.style.alignSelf = .stretch

        return l
    }
}
