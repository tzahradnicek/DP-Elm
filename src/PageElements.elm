module PageElements exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias Model = String

type Msg 
    = Home
    | About
    | Contact

navBarView : Model -> Html Msg
navBarView model = 
    div [ class "navcontainer"] [
        ul [ class "navbar" ]
        [   
            navBarItem model "Home" Home
            , navBarItem model "About" About
            , navBarItem model "Contact" Contact
        ]
    ]

navBarItem : Model -> String -> Msg -> Html Msg
navBarItem model label page = 
    let
        style = "clickable"
    in
        li [] [
            a [ (if model == label then
                class (String.concat [style, " active"] )
                else
                class style), onClick page] [ Html.text label ] ]

update : Msg -> Model -> (Model, Cmd Msg)
update message model = 
    case message of
        Home ->
            ( "Home", Cmd.none)
        About -> 
            ( "About", Cmd.none)
        Contact -> 
            ( "Contact", Cmd.none)

visibleClass: Model -> String -> String -> Attribute msg
visibleClass model input userclass = 
    if model == input then
        class userclass
    else
        class (String.concat ["notvisible ", userclass])

paragprahView: Model -> String -> String -> String -> Html Msg
paragprahView model context elementID content = 
    div [visibleClass model context "textcontainer", id elementID] [
        text content
        , br [] []
    ]

snippetView: Model -> String -> Html Msg
snippetView model codesnippet =
     div [ class "textcontainer"] [
        pre [] [
            code [class "language-elm line-numbers line-highlight"] [
                text codesnippet
            ]
        ]
        , br [] []
    ]
