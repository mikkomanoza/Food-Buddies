//
//  Logger.swift
//  Food Buddies
//
//  Created by John Paul Manoza on 26/03/2017.
//  Copyright © 2017 Nostalgic Kid. All rights reserved.
//


import Foundation

enum LogMode: String {
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

/**
 This is a logging framework class.

 Example: Logger.log(logMode: .info, message: "something happened here")
 Logger.log(logMode: .warning, message: "some warning")
 Logger.log(logMode: .error, message: "some error")
 */
class Logger {
    /**
     This methods prints a log with the desire log mode and message

     Example: Logger.log(logMode: .info, message: "something happened here")
     Logger.log(logMode: .warning, message: "some warning")
     Logger.log(logMode: .error, message: "some error")

     - parameter logMode: logging mode to change heart color, see enum LogMode
     - parameter message: message that you want to print in console
     - parameter file: default file path where Logger was executed
     - parameter function: function where Logger was executed
     - parameter line: line where Logger was executed
     */
    static private func log(logMode: LogMode, message: String, file: String = #file, function: String = #function, line: Int = #line) {
        var emoji = ""
        let filePath = (file as NSString).lastPathComponent
        let messageToPrint = " [Food Buddies /\(logMode.rawValue)/\(filePath)/\(function):\(line)> \(message)"

        switch logMode {
        case .info:
            emoji = "💙"
            NSLog("\n" + emoji + " " + Colors.cyan(messageToPrint), [])
        case .warning:
            emoji = "💛"
            NSLog("\n" + emoji + " " + Colors.Yellow(messageToPrint), [])
        case .error:
            emoji = "❤️"
            NSLog("\n" + emoji + " " + Colors.Red(messageToPrint), [])
        }

    }

    static func i(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.log(logMode: .info, message: message, file: file, function: function, line: line)
    }

    static func w(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.log(logMode: .warning, message: message, file: file, function: function, line: line)
    }

    static func e(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.log(logMode: .error, message: message, file: file, function: function, line: line)
    }

}

struct ANSIColorCode {
    static let black = [0, 9]
    static let red = [1, 9]
    static let green = [2, 9]
    static let yellow = [3, 9]
    static let blue = [4, 9]
    static let magenta = [5, 9]
    static let cyan = [6, 9]
    static let white = [7, 9]
}

struct ANSIModifiers {
    static var bold = [1, 22]
    static var blink = [5, 25]
    static var dim = [2, 22]
    static var italic = [2, 23]
    static var underline = [4, 24]
    static var inverse = [7, 27]
    static var hidden = [8, 28]
    static var strikethrough = [9, 29]
}

func apply<T>(style: [T]) -> ((String) -> String) {
    return { str in return "\u{001B}[\(style[0])m\(str)\u{001B}[\(style[1])m" }
}

func getColor(color: [Int], mod: Int) -> [Int] {
    let terminator = mod == 30 || mod == 90 ? 30 : 40
    return [ color[0] + mod, color[1] + terminator ]
}

public class Colors {
    static let normalText = 30
    static let bg = 40
    static let brightText = 90
    static let brightBg = 100

    // MARK: 8-bit color functions
    public static func getTextColorer(color: Int) -> ((String) -> String) {
        return apply(style: ["38;5;\(color)", String(normalText + 9)])
    }

    public static func colorText(text: String, color: Int) -> String {
        return Colors.getTextColorer(color: color)(text)
    }

    public static func getBgColorer(color: Int) -> ((String) -> String) {
        return apply(style: ["48;5;\(color)", String(bg + 9)])
    }

    public static func colorBg(text: String, color: Int) -> String {
        return Colors.getBgColorer(color: color)(text)
    }

    // MARK: Normal text colors
    public static var black = apply(style: getColor(color: ANSIColorCode.black, mod: normalText))
    public static var red = apply(style: getColor(color: ANSIColorCode.red, mod: normalText))
    public static var green = apply(style: getColor(color: ANSIColorCode.green, mod: normalText))
    public static var yellow = apply(style: getColor(color: ANSIColorCode.yellow, mod: normalText))
    public static var blue = apply(style: getColor(color: ANSIColorCode.blue, mod: normalText))
    public static var magenta = apply(style: getColor(color: ANSIColorCode.magenta, mod: normalText))
    public static var cyan = apply(style: getColor(color: ANSIColorCode.cyan, mod: normalText))
    public static var white = apply(style: getColor(color: ANSIColorCode.white, mod: normalText))

    // MARK: Bright text colors
    public static var Black = apply(style: getColor(color: ANSIColorCode.black, mod: brightText))
    public static var Red = apply(style: getColor(color: ANSIColorCode.red, mod: brightText))
    public static var Green = apply(style: getColor(color: ANSIColorCode.green, mod: brightText))
    public static var Yellow = apply(style: getColor(color: ANSIColorCode.yellow, mod: brightText))
    public static var Blue = apply(style: getColor(color: ANSIColorCode.blue, mod: brightText))
    public static var Magenta = apply(style: getColor(color: ANSIColorCode.magenta, mod: brightText))
    public static var Cyan = apply(style: getColor(color: ANSIColorCode.cyan, mod: brightText))
    public static var White = apply(style: getColor(color: ANSIColorCode.white, mod: brightText))

    // MARK: Normal background colors
    public static var bgBlack = apply(style: getColor(color: ANSIColorCode.black, mod: bg))
    public static var bgRed = apply(style: getColor(color: ANSIColorCode.red, mod: bg))
    public static var bgGreen = apply(style: getColor(color: ANSIColorCode.green, mod: bg))
    public static var bgYellow = apply(style: getColor(color: ANSIColorCode.yellow, mod: bg))
    public static var bgBlue = apply(style: getColor(color: ANSIColorCode.blue, mod: bg))
    public static var bgMagenta = apply(style: getColor(color: ANSIColorCode.magenta, mod: bg))
    public static var bgCyan = apply(style: getColor(color: ANSIColorCode.cyan, mod: bg))
    public static var bgWhite = apply(style: getColor(color: ANSIColorCode.white, mod: bg))

    // MARK: Bright background colors
    public static var BgBlack = apply(style: getColor(color: ANSIColorCode.black, mod: brightBg))
    public static var BgRed = apply(style: getColor(color: ANSIColorCode.red, mod: brightBg))
    public static var BgGreen = apply(style: getColor(color: ANSIColorCode.green, mod: brightBg))
    public static var BgYellow = apply(style: getColor(color: ANSIColorCode.yellow, mod: brightBg))
    public static var BgBlue = apply(style: getColor(color: ANSIColorCode.blue, mod: brightBg))
    public static var BgMagenta = apply(style: getColor(color: ANSIColorCode.magenta, mod: brightBg))
    public static var BgCyan = apply(style: getColor(color: ANSIColorCode.cyan, mod: brightBg))
    public static var BgWhite = apply(style: getColor(color: ANSIColorCode.white, mod: brightBg))

    // MARK: Text modifiers
    public static var bold = apply(style: ANSIModifiers.bold)
    public static var blink = apply(style: ANSIModifiers.blink)
    public static var dim = apply(style: ANSIModifiers.dim)
    public static var italic = apply(style: ANSIModifiers.italic)
    public static var underline = apply(style: ANSIModifiers.underline)
    public static var inverse = apply(style: ANSIModifiers.inverse)
    public static var hidden = apply(style: ANSIModifiers.hidden)
    public static var strikethrough = apply(style: ANSIModifiers.strikethrough)
}

