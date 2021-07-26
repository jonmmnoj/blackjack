//
//  SettingsWIPViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/24/21.
//

import UIKit
import QuickTableViewController

class SettingsWIPViewController:  QuickTableViewController {

  var dynamicRows: [Row & RowStyle] = []

  private var cachedTableContents: [Section] = []

  override var tableContents: [Section] {
    get {
      return cachedTableContents
    }
    set {} // swiftlint:disable:this unused_setter_value
  }

  private let quickTableView = QuickTableView(frame: .zero, style: .grouped)

  override var tableView: UITableView {
    get {
      return quickTableView
    }
    set {} // swiftlint:disable:this unused_setter_value
  }

    
    var isOnn = false
  private func buildContents() -> [Section] {
      return [
        Section(title: "", rows: [
            TapActionRow(
                text: "Start",
                customization: {(cell,row) in
                    cell.backgroundColor = .systemGreen
                    cell.textLabel?.textColor = .white
                    cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
                },
                action: { _ in
                    print("start")
                })
        ]),
        
        Section(title: "", rows: [
            SwitchRow(text: "ENHC (European No Hold Card)", switchValue: isOnn, action: { _ in }),
            SwitchRow(text: "Surrender", switchValue: !isOnn, customization:  { (cell, row) in
                //let c = cell.accessoryView as! UISwitch
                //c.isEnabled = true
                cell.isUserInteractionEnabled = false
                cell.textLabel!.isEnabled = false
               
                
                
            },
            action: { _ in
                //self.isOnn = !self.isOnn
                //self.tableView.reloadData()
            })
        ]),

        Section(title: "Number of Cards", rows: [
            OptionRow(text: "All", isSelected: false, action: didToggleSelection()),
          SwitchRow(text: "2 card hands", switchValue: false, action: { _ in }),
          SwitchRow(text: "3 card hands", switchValue: true, action: { _ in }),
            SwitchRow(text: "4 card hands", switchValue: true, action: { _ in })
        ]),
        
        Section(title: "Type of Hand", rows: [
          SwitchRow(text: "Split", switchValue: false, action: { _ in }),
          SwitchRow(text: "Soft", switchValue: true, action: { _ in }),
            SwitchRow(text: "Hard", switchValue: true, action: { _ in })
        ]),
        
        Section(title: "", rows: [
            TapActionRow(text: "Reset to defaults",
                         customization: {(cell,row) in
                            //cell.backgroundColor =
                            cell.textLabel?.textColor = .systemRed
                        },
                         action: { _ in
                            print("reset")
                         })
        ]),
      ]
  }
    
    private func didToggleSelection() -> (Row) -> Void {
      return { [weak self] in
        if let option = $0 as? OptionRowCompatible {
          let state = "\(option.text) is " + (option.isSelected ? "selected" : "deselected")
          //self?.showDebuggingText(state)
        }
      }
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Dynamic"
    cachedTableContents = buildContents()
    quickTableView.quickDelegate = self
  }

}

extension SettingsWIPViewController: QuickTableViewDelegate {
  func quickReload() {
    //print("!!! quickReload !!!")
    cachedTableContents = buildContents()
  }
}


internal protocol QuickTableViewDelegate: AnyObject {
    func quickReload()
}

open class QuickTableView: UITableView {
    internal weak var quickDelegate: QuickTableViewDelegate?

    override open func reloadData() {
        self.quickDelegate?.quickReload()
        super.reloadData()
    }

  // MARK: Rows

  override open func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
    self.quickDelegate?.quickReload()
    super.reloadRows(at: indexPaths, with: animation)
  }

  override open func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
    self.quickDelegate?.quickReload()
    super.insertRows(at: indexPaths, with: animation)
  }

  override open func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
    self.quickDelegate?.quickReload()
    super.deleteRows(at: indexPaths, with: animation)
  }

  override open func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
    self.quickDelegate?.quickReload()
    super.moveRow(at: indexPath, to: newIndexPath)
  }

  // MARK: Sections

  override open func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
    self.quickDelegate?.quickReload()
    super.reloadSections(sections, with: animation)
  }

  override open func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
    self.quickDelegate?.quickReload()
    super.deleteSections(sections, with: animation)
  }

  override open func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
    self.quickDelegate?.quickReload()
    super.insertSections(sections, with: animation)
  }

  override open func reloadSectionIndexTitles() {
    self.quickDelegate?.quickReload()
    super.reloadSectionIndexTitles()
  }

  override open func moveSection(_ section: Int, toSection newSection: Int) {
    self.quickDelegate?.quickReload()
    super.moveSection(section, toSection: newSection)
  }
}
