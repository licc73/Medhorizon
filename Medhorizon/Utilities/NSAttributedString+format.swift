//
//  NSAttributedString+format.swift
//  ClassesTest
//
//  Created by changchun li on 3/29/16.
//  Copyright © 2016 changchun li. All rights reserved.
//

import Foundation

enum ParseFormatStringState {
    case Unknown
    case Start
    case StartPositional
    case EndPositional
}

struct FormatParseResult {
    var range: NSRange
    var index: Int
    init(range: NSRange, index: Int) {
        self.range = range
        self.index = index
    }
}

extension String {
    
    private func isdigit() -> Bool {
        if let _ = Int(self) {
            return true
        }
        else {
            return false
        }
    }
    
}

func parserFormateString(format: String) -> ([FormatParseResult], Int) {
    var parserResults: [FormatParseResult] = []
    var position: Int = 1 // Position is incrememented each time an %@ is found.Because format is start with %1$@,for uniformity
    var maxPosition: Int = 0
    var start = NSNotFound
    var positionString: String?
    var parserState = ParseFormatStringState.Unknown
    var index: Int = 0
    for character in format.characters {
        if character == "%" {
            start = index
            parserState = .Start
        }
        else if parserState != .Unknown {
            if character == "@" {
                var currentPosition: Int
                if let _positionString = positionString {
                    currentPosition = Int(_positionString) ?? 1
                    positionString = nil
                }
                else {
                    currentPosition = position
                    position += 1
                }
                
                let result = FormatParseResult(range: NSRange(location: start, length: index + 1 - start), index: currentPosition - 1)
                parserResults.append(result)
                maxPosition = max(maxPosition, currentPosition)
                parserState = .Unknown
            }
            else if (parserState == .Start || parserState == .StartPositional) && String(character).isdigit() {
                if positionString == nil {
                    positionString = String(stringInterpolationSegment: character)
                }
                else {
                    positionString!.append(character)
                }
                parserState = .StartPositional
            }
            else if parserState == .StartPositional && character == "$" {
                parserState = .EndPositional
            }
            else {
                parserState = .Unknown
            }
        }
        index += 1
    }
    
    return (parserResults, maxPosition)
}

extension NSAttributedString {
    
    convenience init(format: String, _ arguments: AnyObject...) {
        self.init(attributes: nil, format: format, arguments)
    }
    
    convenience init(attributes: [String : AnyObject]?, format: String, _ arguments: AnyObject...) {
        self.init(attributes: attributes, format: format, arguments)
    }
    
    private convenience init(attributes: [String : AnyObject]?, format: String, _ arguments: [AnyObject]) {
        let attributedString: NSMutableAttributedString
        if nil == attributes {
            attributedString = NSMutableAttributedString(string: format)
        }
        else {
            attributedString = NSMutableAttributedString(string: format, attributes: attributes)
        }
        
        attributedString.beginEditing()
        let (parserResults, _) = parserFormateString(format)
        let sortedParseResult = parserResults.sort { (lhs, rhs) -> Bool in
            return lhs.range.location > rhs.range.location
        }
        
        for formatResult in sortedParseResult {
            var arg = arguments[formatResult.index]
            if arg is NSAttributedString {
                if nil != attributes {
                    let argCopy = NSMutableAttributedString(string: arg.string)
                    argCopy.setAttributes(attributes, range: NSRange(location: 0, length: argCopy.length))
                    
                    arg.enumerateAttributesInRange(NSRange(location: 0, length: argCopy.length), options: NSAttributedStringEnumerationOptions(rawValue: 0), usingBlock: { (dicAttr, range, stop) -> Void in
                        argCopy.addAttributes(dicAttr, range: range)
                    })
                    arg = argCopy
                }
                attributedString.replaceCharactersInRange(formatResult.range, withAttributedString: arg as! NSAttributedString)
            }
            else if arg is String {
                attributedString.replaceCharactersInRange(formatResult.range, withString: arg as! String)
            }
        }
        
        attributedString.endEditing()
        
        self.init(attributedString: attributedString)
    }
}
