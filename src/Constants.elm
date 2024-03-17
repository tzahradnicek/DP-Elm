module Constants exposing (..)
import Dict exposing (Dict)

type alias Model = 
    {
        nums: Dict String Int
        ,highl: String
        ,currPage: String
    }


nums: Dict String Int
nums = Dict.fromList
    [
        ("pics", 1)
        ,("pics2", 1)
        ,("pics3", 1)
        ,("pats", 1)
    ]

pics : Dict Int String
pics = Dict.fromList
    [
        (0, "pics")
        ,(1, "img/cat.png")
        ,(2, "img/dog.png")
        ,(3, "img/monkey.png")
        ,(4, "img/donkey.png")
    ]

pics2 : Dict Int String
pics2 = Dict.fromList
    [
        (0, "pics2")
        ,(4, "img/cat.png")
        ,(1, "img/dog.png")
        ,(3, "img/monkey.png")
        ,(2, "img/donkey.png")
    ]

pics3 : Dict Int String
pics3 = Dict.fromList
    [
        (0, "pics3")
        ,(2, "img/cat.png")
        ,(3, "img/dog.png")
        ,(1, "img/donkey.png")
    ]

pats : Dict Int String
pats = Dict.fromList
    [
        (0, "pats")
        ,(1, "img/pat1.png")
        ,(2, "img/pat2.png")
        ,(3, "img/pat3.png")
    ]
highlight : Dict String String
highlight = Dict.fromList
    [
        ("one", "img/cat.png")
        ,("two", "img/dog.png")
        ,("three", "img/donkey.png")
        ,("four", "img/monkey.png")
    ]

grid : Dict String String
grid = Dict.fromList
    [
        ("one", "img/cat.png")
        ,("two", "img/dog.png")
        ,("three", "img/donkey.png")
        ,("four", "img/monkey.png")
    ]
