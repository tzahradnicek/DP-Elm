module Gallery exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Time
import Files exposing(pics, pics2, pics3)

type alias Model = 
    {
        nums: Dict String Int
        ,count: Int
    }

type Msg = Prev (Dict Int String) | Next (Dict Int String) | Tick Time.Posix

getModelNum : Dict Int String -> Model -> Int
getModelNum pics model = 
    (case Dict.get 
        (case Dict.get 0 pics of
            Just value -> value
            Nothing -> "text") model.nums of 
                Just smth -> smth
                Nothing -> -1)

getPicKey : Dict Int String -> String
getPicKey picdict = 
    (case Dict.get 0 picdict of
        Just value -> value
        Nothing -> "text")

-- minus 2 to get the number of images in dict
dictSize dict = 
    ((Dict.size dict) - 2)

-- variable used in the update for all the gallery views that should be ticking automatically
keysToUpdate =
    [ ("pics", dictSize pics), ("pics2", dictSize pics2), ("pics3", dictSize pics3) ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Next dict ->
        let 
            modelNum = getModelNum dict model
            picKey = getPicKey dict
        in 
        if modelNum > dictSize dict then
            ({ model | nums = Dict.update picKey (\value -> Just 1) model.nums}, Cmd.none)
        else 
            ({ model | nums = Dict.update picKey (Maybe.map (\value -> value + 1)) model.nums}, Cmd.none)
    Prev dict ->
        let 
            modelNum = getModelNum dict model
            picKey = getPicKey dict
        in 
        if modelNum == 1 then
            ({ model | nums = Dict.update picKey (\value -> Just ((Dict.size dict) - 1)) model.nums}, Cmd.none)
        else 
            ({ model | nums = Dict.update picKey (Maybe.map (\value -> value - 1)) model.nums}, Cmd.none)
    Tick time ->
        let
            updateValue key len value =
                Maybe.map (\v -> 
                if v > len then
                    1
                else 
                    v + value)
            updateKey (key, len) dict =
                Dict.update key (updateValue key len 1) dict
            updateKeys keys dict =
                List.foldl updateKey dict keys
        in
            ({model | nums = updateKeys keysToUpdate model.nums}, Cmd.none)



galleryView : Model -> Dict Int String -> List String -> List String -> Html Msg
galleryView model picDict picPosition picStyle =
    div [ class (String.join " " picPosition) ] [
        img [src (case Dict.get 
                    (case Dict.get 
                        (case Dict.get 0 picDict of
                            Just value -> value
                            Nothing -> "text") model.nums of 
                        Just smth -> smth
                        Nothing -> -1) picDict of
                    Just value -> value
                    Nothing -> "text"), class (String.join " " picStyle)] []
        , button [ class "centerLeft leftArrow", onClick (Prev picDict)] []
        , button [ class "centerRight rightArrow" , onClick (Next picDict)] [] 
    ]


