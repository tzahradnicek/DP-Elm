module Grid exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)

type alias Model = 
    { items : List String }

type Msg
    = NoOp

generateGrid : List String -> Html Msg
generateGrid list = 
    let
        firstElem = case List.head list of
            Just first -> first 
            Nothing -> ""
        secondElem = case List.tail list of
            Just rest ->
                case List.head rest of
                    Just second -> second 
                    Nothing -> ""
            Nothing -> ""
    in
        div [ class (String.concat ["grid_item ", secondElem])] [
            img [src (String.concat ["img/", firstElem]), class "grid_img"] []
   ]

gridView : List (List String) -> Html Msg
gridView listOfLists =
    div [ class "grid" ] 
       (List.map generateGrid listOfLists)

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp -> model