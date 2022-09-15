//
//  main.swift
//  radio
//
//  Created by Joachim Dorel on 05/09/2022.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
