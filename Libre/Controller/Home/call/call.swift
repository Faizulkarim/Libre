//
//  call.swift
//  Libre
//
//  Created by Faizul Karim on 15/12/21.
//

import Foundation
import Foundation

enum CallState {
    case connecting
    case active
    case held
    case ended
}

enum ConnectedState {
    case pending
    case complete
}

class Call {
    
    let uuid: UUID
    let outgoing: Bool
    let handle: String
    
    var state: CallState = .ended {
        didSet {
            stateChanged?()
        }
    }
    
    var connectedState: ConnectedState = .pending {
        didSet {
            connectedStateChanged?()
        }
    }
    
    var stateChanged: (() -> Void)?
    var connectedStateChanged: (() -> Void)?
    
    init(uuid: UUID, outgoing: Bool = false, handle: String) {
        self.uuid = uuid
        self.outgoing = outgoing
        self.handle = handle
    }
    
    func start(completion: ((_ success: Bool) -> Void)?) {
        completion?(true)
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 3) {
            self.state = .connecting
            self.connectedState = .pending
            
            DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
                self.state = .active
                self.connectedState = .complete
            }
        }
    }
    
    func answer() {
        state = .active
        GlobalAPI.shared.APICallStatusChange(status: 2) { success in
            
            if success{
               
               
            }
        }
        print("Active")
    }
    
    func end() {
        state = .ended
        print("Ended")
        GlobalAPI.shared.APICallStatusChange(status: 1) { success in
            
            if success{
                print(success)
               
            }
        }
    }
    
}
