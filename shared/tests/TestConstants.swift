//
//  Constants.swift
//  voluxe-customerAPITests
//
//  Created by Christoph on 6/5/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

struct TestConstants {

    // MARK:- First and last names

    struct Names {

        static let invalid = ["this name has exactly 51 characters in it too long ",
                              "this name has too many characters in it to be accepted in the database"]

        static let valid = ["",
                            "A",
                            "name",
                            "emojis 😶🍩🆒",
                            "this name has exactly 50 characters in it and isOK",
                            "mixed le77ers and numb3rs",
                            "special characters !@#$%^&*()",
                            "option characters üîøåé"]
    }

    // MARK:- Email addresses

    struct Emails {

        static let invalid = ["",
                              "thisemailistoolongandhastoomanycharacters12345678901234567890@email.com",
                              "bademailnoatsymbol.com",
                              "@nouser.com"]

        static let valid = ["user@domain.com",
                            "bademail@nodomain"]
    }

    // MARK:- Phone numbers

    struct Phones {

        static let invalid = ["",
                              "1234567890987654321",
                              "abc def ghij",
                              "11 22 33 44 55 66 77 88 99",
                              "😶🍩🆒 😶🍩🆒 💨🍆💉📍",
                              "😶🍩🆒 555 💨🍆💉📍"]
    }

    // MARK:- Language codes

    struct Languages {

        static let invalid = ["EN-uk",
                              "ZZ",
                              "00",
                              "0A",
                              "😶🍩"]
    }

    // MARK:- Passwords

    struct Passwords {

        static let invalid = ["",
                              "123abc",
                              "12345678",
                              "abcdefgh",
                              "abcdefghijABCDEFGHIJ01234567890123456789012345678901234567890123456789"]

        static let valid = ["abcd1234",
                            "abcd1234!@#$",
                            "abcd1234😶🍩🆒"]
    }
}
