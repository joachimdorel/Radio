//
//  AppDelegate.swift
//  radio
//
//  Created by Joachim Dorel on 05/09/2022.
//

import Cocoa
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    
    let radios = [
        Radio(name: "FIP", url: "https://icecast.radiofrance.fr/fip-hifi.aac"),
        Radio(name: "Radio Valentín Letelier", url: "https://cast235.indax.cl/8026/stream")
    ]
    
    var player:AVPlayer!
    var currentRadioID = 0 // on start the current radio in the first one in the list
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        player = AVPlayer(url: radios[currentRadioID].url)
        player.play()
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "play.circle", accessibilityDescription: "2")
        }

        statusItem.menu = setupMenus()
    }
    
    func setupMenus() -> NSMenu {
        let menu = NSMenu()
        
//        TODO: V0.2 -> display the name of the radio
        let currentRadioItem = NSMenuItem(title: radios[currentRadioID].name, action: nil, keyEquivalent: "")
        menu.addItem(currentRadioItem)
        
        menu.addItem(NSMenuItem.separator())

        let play = NSMenuItem(title: "Play", action: #selector(play), keyEquivalent: "1")
        menu.addItem(play)
        
        let pause = NSMenuItem(title: "Pause", action: #selector(pause), keyEquivalent: "2")
        menu.addItem(pause)
        
        let nextRadio = NSMenuItem(title: "Next Radio", action: #selector(nextRadio), keyEquivalent: "3")
        menu.addItem(nextRadio)
        
        let previousRadio = NSMenuItem(title: "Previous Radio", action: #selector(previousRadio), keyEquivalent: "4")
        menu.addItem(previousRadio)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        return menu
    }

    private func changeStatusBarButton(systemSymbolName: String) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: systemSymbolName)
        }
    }
    
    @objc func play() {
        player.play()
        changeStatusBarButton(systemSymbolName: "play.circle")

    }
    
    @objc func pause() {
        player.pause()
        changeStatusBarButton(systemSymbolName: "pause.circle")
    }
    
    @objc func nextRadio(currentRadioItem: NSMenuItem) {
        changeRadio(direction: "previous")
    }
    
    @objc func previousRadio(currentRadioItem: NSMenuItem) {
        changeRadio(direction: "next")
    }
    
    func changeRadio(direction: String) {
        player.pause()
        let numberOfRadios = radios.count
        
        let idPrevRadio = currentRadioID-1 >= 0 ? currentRadioID-1 : numberOfRadios-1
        let idNextRadio = currentRadioID+1 < numberOfRadios ? currentRadioID+1 : 0

        if (direction == "previous") {
            currentRadioID = idPrevRadio
        }
            
        if (direction == "next") {
            currentRadioID = idNextRadio
        }
        
        player = AVPlayer(url: radios[currentRadioID].url)
        player.play()
        
        if (player.currentItem!.status == AVPlayerItem.Status.failed) {
            print("loading the stream failed :(")
        }

        
        // 💡 idea: use a radio shorthand (like FIP, RVL...) in the class Radio to select the currentRadio by shorthand ?
        let radioNameMenuItem = statusItem.menu?.item(at: 0)
        radioNameMenuItem?.title = radios[currentRadioID].name
        statusItem.menu?.itemChanged(radioNameMenuItem!)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}
