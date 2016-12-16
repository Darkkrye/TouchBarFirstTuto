//
//  TouchBarIdentifiers.swift
//  TouchBar
//
//  Created by Andy Pereira on 10/31/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import AppKit

extension NSTouchBarItemIdentifier {
  static let infoLabelItem = NSTouchBarItemIdentifier("com.razeware.InfoLabel")
  static let visitedLabelItem = NSTouchBarItemIdentifier("com.razeware.VisitedLabel")
  static let visitSegmentedItem = NSTouchBarItemIdentifier("com.razeware.VisitedSegementedItem")
  static let visitedItem = NSTouchBarItemIdentifier("com.razeware.VisitedItem")
  static let ratingLabel = NSTouchBarItemIdentifier("com.razeware.RatingLabel")
  static let ratingScrubber = NSTouchBarItemIdentifier("com.razeware.RatingScrubber")
  static let saveItem = NSTouchBarItemIdentifier("com.razeware.SaveItem")
}

extension NSTouchBarCustomizationIdentifier {
  static let travelBar = NSTouchBarCustomizationIdentifier("com.razeware.ViewController.TravelBar")
}
