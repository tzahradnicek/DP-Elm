module Files exposing (pics, pics2, pics3)
import Dict exposing (Dict)

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
