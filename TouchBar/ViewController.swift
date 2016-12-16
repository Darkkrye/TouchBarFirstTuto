//
//  ViewController.swift
//  TouchBar
//
//  Created by Chris Ricker on 10/28/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  @IBOutlet var nameField: NSTextField!
  
  var visited = 0
  var rating = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(OSX 10.12.2, *) {
      nameField.isAutomaticTextCompletionEnabled = false
    }
  }
  
  @IBAction func save(_ sender: Any) {
    willChangeValue(forKey: "rating")
    willChangeValue(forKey: "visited")
    rating = 0
    visited = 0
    nameField.stringValue = ""
    didChangeValue(forKey: "rating")
    didChangeValue(forKey: "visited")
  }
  
  @IBAction func changevisitedAmount(_ sender: NSSegmentedControl) {
    willChangeValue(forKey: "visited")
    switch sender.selectedSegment {
    case 0:
      if visited > 0 {
        visited -= 1
      }
    case 1:
      visited += 1
    default:
      break
    }
    didChangeValue(forKey: "visited")
  }
  
  @IBAction func changeRating(_ sender: NSSegmentedControl) {
    willChangeValue(forKey: "rating")
    switch sender.selectedSegment {
    case 0:
      if rating > 0 {
        rating -= 1
      }
    case 1:
      if rating < 4 {
        rating += 1
      }
    default:
      break
    }
    didChangeValue(forKey: "rating")
  }
  
}

// MARK: - Scrubber DataSource & Delegate

@available(OSX 10.12.2, *)
extension ViewController: NSScrubberDataSource, NSScrubberDelegate {
  
  func numberOfItems(for scrubber: NSScrubber) -> Int {
    return 5
  }
  
  func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
    let itemView = scrubber.makeItem(withIdentifier: "RatingScrubberItemIdentifier", owner: nil) as! NSScrubberTextItemView
    itemView.textField.stringValue = String(index)
    return itemView
  }
  
  func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
    willChangeValue(forKey: "rating")
    rating = index
    didChangeValue(forKey: "rating")
  }
  
}

// MARK: - TouchBar Delegate
@available(OSX 10.12.2, *)
extension ViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        // Create a new TouchBar
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        
        // Set the customizationIdentifier. Remember, every TouchBar and TouchBarItem need to have unique identifiers
        touchBar.customizationIdentifier = .travelBar
        
        // Set the Touch Bar's default item identifiers. This tells the Touch Bar what items it will contain
        touchBar.defaultItemIdentifiers = [.infoLabelItem, .flexibleSpace, .ratingLabel, .ratingScrubber, .flexibleSpace, .visitedLabelItem, .visitedItem, .visitSegmentedItem, .flexibleSpace, .saveItem]
        
        // Here, you set what order the items should be presented to the user
        touchBar.customizationAllowedItemIdentifiers = [.infoLabelItem]
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        print(identifier)
        switch identifier {
        case NSTouchBarItemIdentifier.infoLabelItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "\u{1F30E} \u{1F4D3}")
            return customViewItem
            
        case NSTouchBarItemIdentifier.ratingLabel:
            // A new item was created to show a label for ratings
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "Rating")
            return customViewItem
            
        case NSTouchBarItemIdentifier.ratingScrubber:
            // Here, a custom item is created to hold an NSScrubber. This is a new control introduced for the TouchBar. They behave similar to a slider, but can be customized specificially for working in the bar. Since scrubbers require a delegate to handle events, all you need to do here is set the delegate, which ViewController already has implemented for you.
            let scrubberItem = NSCustomTouchBarItem(identifier: identifier)
            let scrubber = NSScrubber()
            scrubber.scrubberLayout = NSScrubberFlowLayout()
            scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: "RatingScrubberItemIdentifier")
            scrubber.mode = .fixed
            scrubber.selectionBackgroundStyle = .roundedBackground
            scrubber.delegate = self
            scrubber.dataSource = self
            scrubberItem.view = scrubber
            scrubber.bind("selectedIndex", to: self, withKeyPath: #keyPath(rating), options: nil)
            return scrubberItem
            
        case NSTouchBarItemIdentifier.visitedLabelItem:
            // This creates a simple label, just like in previous steps.
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "Times Visited")
            return customViewItem
            
        case NSTouchBarItemIdentifier.visitedItem:
            // Here, you create another label, but you bind the value of the text to a property. Just like the scrubber binding values to make updating Touch Bar items very easy
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "--")
            customViewItem.view.bind("value", to: self, withKeyPath: #keyPath(visited), options: nil)
            return customViewItem
            
        case NSTouchBarItemIdentifier.visitSegmentedItem:
            // Finally, you create a segmented control to be displayed in a touch bar item. You can see that setting up a target and action is just the same as it always is
            let customActionItem = NSCustomTouchBarItem(identifier: identifier)
            let segmentedControl = NSSegmentedControl(images: [NSImage(named: NSImageNameRemoveTemplate)!, NSImage(named: NSImageNameAddTemplate)!], trackingMode: .momentary, target: self, action: #selector(changevisitedAmount(_:)))
            segmentedControl.setWidth(40, forSegment: 0)
            segmentedControl.setWidth(40, forSegment: 1)
            customActionItem.view = segmentedControl
            return customActionItem
            
        case NSTouchBarItemIdentifier.saveItem:
            let saveItem = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(title: "Save", target: self, action: #selector(save(_:)))
            button.bezelColor = NSColor(red: 0.35, green: 0.61, blue: 0.35, alpha: 1)
            saveItem.view = button
            return saveItem
            
        default:
            return nil
        }
    }
}
