//
//  PrintJobManager.swift
//  flutter_inappwebview
//
//  Created by Lorenzo Pichilli on 09/05/22.
//

import Foundation

public class PrintJobManager: NSObject, Disposable {
    var plugin: SwiftFlutterPlugin?
    var jobs: [String: PrintJobController?] = [:]
    
    public init(plugin: SwiftFlutterPlugin?) {
        super.init()
        self.plugin = plugin
    }
    
    public func dispose() {
        let jobValues = jobs.values
        jobValues.forEach { (job: PrintJobController?) in
            job?.dispose()
        }
        jobs.removeAll()
        plugin = nil
    }
    
    deinit {
        dispose()
    }
}
