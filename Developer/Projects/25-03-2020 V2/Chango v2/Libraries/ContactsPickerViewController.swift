import UIKit
import ContactsUI

extension UIAlertController {
    
    /// Add Contacts Picker
    ///
    /// - Parameters:
    ///   - selection: action for selection of contact
    
    func addContactsPicker(selection: ContactsPickerViewController.Selection) {
        let selection: ContactsPickerViewController.Selection = selection
        var contact: Contact?
		var contacts: [Contact] = []
        
        let addContact = UIAlertAction(title: "Add Contact", style: .default) { action in
            switch selection {
				
			case .single(let action):
				action?(contact)
				
			case .multiple(let action):
				action?(contacts)
			}
        }
        addContact.isEnabled = false
        
        let vc = ContactsPickerViewController(selection: {
            switch selection {
			case .single(_):
				return .single(action: { new in
					addContact.isEnabled = new != nil
					contact = new
				})
			case .multiple(_):
				return .multiple(action: { new in
					addContact.isEnabled = new.count > 0
					contacts = new
				})
			}
			
		}())
        
        set(vc: vc)
        addAction(addContact)
    }
}

final class ContactsPickerViewController: UIViewController {
    
    // MARK: UI Metrics
    
    struct UI {
        static let rowHeight: CGFloat = 58
        static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
	
	public typealias SingleSelection = (Contact?) -> Swift.Void
	public typealias MultipleSelection = ([Contact]) -> Swift.Void
	
	public enum Selection {
		case single(action: SingleSelection?)
		case multiple(action: MultipleSelection?)
	}
	
	fileprivate var selection: Selection?
    //Contacts ordered in dicitonary alphabetically
    fileprivate var orderedContacts = [String: [CNContact]]()
    fileprivate var sortedContactKeys = [String]()
    fileprivate var filteredContacts: [CNContact] = []
    
    fileprivate var selectedContact: Contact?
	fileprivate var selectedContacts: [Contact?] = []
    
    fileprivate lazy var searchView: UIView = UIView()
    
    fileprivate lazy var searchController: UISearchController = {
        $0.searchResultsUpdater = self
        $0.searchBar.delegate = self
        $0.dimsBackgroundDuringPresentation = false
        /// true if search bar in tableView header
        $0.hidesNavigationBarDuringPresentation = true
        $0.searchBar.searchBarStyle = .minimal
       // $0.searchBar.textField?.textColor = .black
       // $0.searchBar.textField?.clearButtonMode = .whileEditing
        return $0
    }(UISearchController(searchResultsController: nil))
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.rowHeight = UI.rowHeight
        $0.separatorColor = UI.separatorColor
        $0.bounces = true
        $0.backgroundColor = nil
        $0.tableFooterView = UIView()
        $0.sectionIndexBackgroundColor = .clear
        $0.sectionIndexTrackingBackgroundColor = .clear
        $0.register(ContactTableViewCell.self,
                    forCellReuseIdentifier: ContactTableViewCell.identifier)
        return $0
        }(UITableView(frame: .zero, style: .plain))
	
	required public init(selection: Selection) {
		super.init(nibName: nil, bundle: nil)
		
		self.selection = selection
		switch selection {
			
		case .single(_):
			tableView.allowsSelection = true
		case .multiple(_):
			tableView.allowsMultipleSelection = true
		}
	}
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // http://stackoverflow.com/questions/32675001/uisearchcontroller-warning-attempting-to-load-the-view-of-a-view-controller/
        // let _ = searchController.view
        Log("has deinitialized")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width / 2
        }
        
        searchView.addSubview(searchController.searchBar)
        tableView.tableHeaderView = searchView
        
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .bottom
        definesPresentationContext = true

        updateContacts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.tableHeaderView?.height = 57
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame.size.width = searchView.frame.size.width
        searchController.searchBar.frame.size.height = searchView.frame.size.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize.height = tableView.contentSize.height
        Log("preferredContentSize.height = \(preferredContentSize.height), tableView.contentSize.height = \(tableView.contentSize.height)")
    }
    
    func updateContacts() {
        checkStatus { [unowned self] orderedContacts in
            
            self.orderedContacts = orderedContacts
            self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
            
            if self.sortedContactKeys.first == "#" {
                self.sortedContactKeys.removeFirst()
                self.sortedContactKeys.append("#")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func checkStatus(completionHandler: @escaping ([String: [CNContact]]) -> ()) {
        Log("status = \(CNContactStore.authorizationStatus(for: .contacts))")
        switch CNContactStore.authorizationStatus(for: .contacts) {
            
        case .notDetermined:
            /// This case means the user is prompted for the first time for allowing contacts
            Contacts.requestAccess { [unowned self] bool, error in
                self.checkStatus(completionHandler: completionHandler)
            }
            
        case .authorized:
            /// Authorization granted by user for this app.
            DispatchQueue.main.async {
                self.fetchContacts(completionHandler: completionHandler)
            }

        case .denied, .restricted:
            /// User has denied the current app to access the contacts.
            let productName = Bundle.main.infoDictionary!["CFBundleName"]!
            let alert = UIAlertController(style: .alert, title: "Permission denied", message: "\(productName) does not have access to contacts. Please, allow the application to access to your contacts.")
            alert.addAction(title: "Settings", style: .destructive) { action in
				if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (action) in
				alert.dismiss(animated: true)
			}))
            alert.show()
        }
    }
    
    func fetchContacts(completionHandler: @escaping ([String: [CNContact]]) -> ()) {
        Contacts.fetchContactsGroupedByAlphabets { [unowned self] result in
            switch result {
                
            case .success(let orderedContacts):
                completionHandler(orderedContacts)
                
            case .error(let error):
                Log("------ error")
				let alert = UIAlertController(style: .alert, title: "Error", message: error.localizedDescription)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
					alert.dismiss(animated: true)
				}))
                alert.show()
            }
        }
    }
    
    func contact(at indexPath: IndexPath) -> Contact? {
        if searchController.isActive {
            return Contact(contact: filteredContacts[indexPath.row])
        }
        let key: String = sortedContactKeys[indexPath.section]
        if let contact = orderedContacts[key]?[indexPath.row] {
            return Contact(contact: contact)
        }
        return nil
    }
    
    func indexPathOfSelectedContact() -> IndexPath? {
        guard let selectedContact = selectedContact else { return nil }
        if searchController.isActive {
            for row in 0 ..< filteredContacts.count {
                if filteredContacts[row] == selectedContact.value {
                    return IndexPath(row: row, section: 0)
                }
            }
        }
        for section in 0 ..< sortedContactKeys.count {
            if let orderedContacts = orderedContacts[sortedContactKeys[section]] {
                for row in 0 ..< orderedContacts.count {
                    if orderedContacts[row] == selectedContact.value {
                        return IndexPath(row: row, section: section)
                    }
                }
            }
        }
        return nil
    }
}

// MARK: - UISearchResultsUpdating

extension ContactsPickerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchController.isActive {
            Contacts.searchContact(searchString: searchText) { [unowned self] result in
                switch result {
                case .success(let contacts):
                    self.filteredContacts = contacts
                    self.tableView.reloadData()
                case .error(let error):
                    Log(error.localizedDescription)
                    self.tableView.reloadData()
                }
            }
        } else {
            tableView.reloadData()
        }
        
        guard let selectedIndexPath = indexPathOfSelectedContact() else { return }
        Log("selectedIndexPath = \(selectedIndexPath)")
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
}

// MARK: - UISearchBarDelegate

extension ContactsPickerViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension Array {
	func contains<T>(obj: T) -> Bool where T : Equatable {
		return self.filter({$0 as? T == obj}).count > 0
	}
}

// MARK: - TableViewDelegate

extension ContactsPickerViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let contact1 = contact(at: indexPath)
		switch selection {
			
		case .single(let action)?:
			action?(contact1)
			
		case .multiple(let action)?:
			if selectedContacts.contains(contact1) {
				if let index = selectedContacts.index(where: {$0 == contact1}) {
					selectedContacts.remove(at: index)
				}
			}else{
				selectedContacts.append(contact1)
				action?(selectedContacts as! [Contact])
			}
			
		case .none: break }
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		let contact1 = contact(at: indexPath)
		switch selection {
		case .multiple(let action)?:
			if selectedContacts.contains(contact1) {
				if let index = selectedContacts.index(where: {$0 == contact1}) {
					selectedContacts.remove(at: index)
				}
			}else{
				selectedContacts.append(contact1)
				action?(selectedContacts as! [Contact])
			}
		default: break }
	}
	
	/*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let contact = contact(at: indexPath) else { return }
		selectedContact = contact
		if selectedContacts.contains(contact) {
			if let index = selectedContacts.index(where: {$0 == contact}) {
				selectedContacts.remove(at: index)
			}
		}else{
			selectedContacts.append(contact)
		}
		Log(selectedContact?.displayName)
		selection?(selectedContact)
		selections?(selectedContacts)
		
		
	}*/
	
}

// MARK: - TableViewDataSource

extension ContactsPickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive { return 1 }
        return sortedContactKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive { return filteredContacts.count }
        if let contactsForSection = orderedContacts[sortedContactKeys[section]] {
            return contactsForSection.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchController.isActive { return 0 }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top , animated: false)
        return sortedContactKeys.index(of: title)!
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive { return nil }
        return sortedContactKeys
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive { return nil }
        return sortedContactKeys[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier) as! ContactTableViewCell
       
        guard let contact = contact(at: indexPath) else { return UITableViewCell() }
        
        if let selectedContact = selectedContact, selectedContact.value == contact.value {
            cell.setSelected(true, animated: true)
            Log("indexPath = \(indexPath) is selected - \(contact.displayName) = \(cell.isSelected)")
            //cell.isSelected = true
        }
        
        cell.configure(with: contact)
        return cell
    }
}
