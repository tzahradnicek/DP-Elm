module Gallery exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Time

type alias Model = 
    Dict String Int

type Msg = Prev (Dict Int String) | Next (Dict Int String) | Tick Time.Posix

getModelNum : Dict Int String -> Model -> Int
getModelNum pics model = 
    (case Dict.get 
        (case Dict.get 0 pics of
            Just value -> value
            Nothing -> "text") model of 
                Just smth -> smth
                Nothing -> -1)

getPicKey : Dict Int String -> String
getPicKey picdict = 
    (case Dict.get 0 picdict of
        Just value -> value
        Nothing -> "text")

-- minus 2 to get the number of images in dict
dictSize : Dict Int String -> Int
dictSize dict = 
    ((Dict.size dict) - 2)

update : Msg -> Model -> List (String, Int) -> (Model, Cmd Msg)
update msg model keysToUpdate =
  case msg of
    Next dict ->
        let 
            modelNum = getModelNum dict model
            picKey = getPicKey dict
        in 
        if modelNum > dictSize dict then
            ( Dict.update picKey (\value -> Just 1) model, Cmd.none)
        else 
            ( Dict.update picKey (Maybe.map (\value -> value + 1)) model, Cmd.none)
    Prev dict ->
        let 
            modelNum = getModelNum dict model
            picKey = getPicKey dict
        in 
            if modelNum == 1 then
                ( Dict.update picKey (\value -> Just ((Dict.size dict) - 1)) model, Cmd.none)
            else 
                ( Dict.update picKey (Maybe.map (\value -> value - 1)) model, Cmd.none)
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
            ( updateKeys keysToUpdate model, Cmd.none)



galleryView : Model -> Dict Int String -> List String -> List String -> Html Msg
galleryView model picDict picPosition picStyle =
    div [ class (String.join " " picPosition) ] [
        img [src (case Dict.get 
                    (case Dict.get 
                        (case Dict.get 0 picDict of
                            Just value -> value
                            Nothing -> "text") model of 
                        Just smth -> smth
                        Nothing -> -1) picDict of
                    Just value -> value
                    Nothing -> "text"), class (String.join " " picStyle)] []
        , button [ class "centerLeft leftArrow", onClick (Prev picDict)] []
        , button [ class "centerRight rightArrow" , onClick (Next picDict)] [] 
    ]


