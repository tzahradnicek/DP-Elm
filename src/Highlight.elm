module Highlight exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)

type alias Model = 
    String

type Msg = One
        | Two
        | Three
        | Four

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    One ->
        ( "one", Cmd.none)
    Two ->
        ( "two", Cmd.none)
    Three ->
        ( "three", Cmd.none)
    Four ->
        ( "four", Cmd.none)



highlightView : Model -> Dict String String -> Html Msg
highlightView model picDict =
    div [] [
        div [ class "row" ] [
            button [ onClick One, class "column button-img" ] [ img [src (case Dict.get "one" picDict of
                                                            Just value -> value
                                                            Nothing -> "text"), if model == "one" then class "selected" else class ""] []]
            ,button [ onClick Two, class "column button-img" ] [ img [src (case Dict.get "two" picDict of
                                                            Just value -> value
                                                            Nothing -> "text"), if model == "two" then class "selected" else class ""] []]
            ,button [ onClick Three, class "column button-img" ] [ img [src (case Dict.get "three" picDict of
                                                            Just value -> value
                                                            Nothing -> "text"), if model == "three" then class "selected" else class ""] []]
            ,button [ onClick Four, class "column button-img" ] [ img [src (case Dict.get "four" picDict of
                                                            Just value -> value
                                                            Nothing -> "text"), if model == "four" then class "selected" else class ""] []]
        ]
        ,div  [class "container" ] [
            img [src (case Dict.get model picDict of
                    Just value -> value
                    Nothing -> "text"), class "fullwidth"] []
        ]
    ]


