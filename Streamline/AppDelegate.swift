//
//  AppDelegate.swift
//  Streamline
//
//  Created by Alexis Rondeau on 27.11.22.
//

import Foundation
import AppKit

public class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationWillUpdate(_ notification: Notification) {
        DispatchQueue.main.async {
            let currentMainMenu = NSApplication.shared.mainMenu

            let editMenu: NSMenuItem? = currentMainMenu?.item(withTitle: "Edit")
            if nil != editMenu {
                NSApp.mainMenu?.removeItem(editMenu!)
            }

            let windowMenu: NSMenuItem? = currentMainMenu?.item(withTitle: "Window")
            if nil != windowMenu {
                NSApp.mainMenu?.removeItem(windowMenu!)
            }

            let viewMenu: NSMenuItem? = currentMainMenu?.item(withTitle: "View")
            if nil != viewMenu {
                NSApp.mainMenu?.removeItem(viewMenu!)
            }
        }
    }
}
