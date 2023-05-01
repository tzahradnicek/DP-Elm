module Main exposing (main)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Gallery exposing(..)
import Files exposing(pics, pics2, pics3)
import Time

type alias Model = 
    {
        nums: Dict String Int
    }

nums: Dict String Int
nums = Dict.fromList
    [
        ("pics", 1)
        ,("pics2", 1)
        ,("pics3", 1)
    ]
    

initialModel : () -> (Model, Cmd Msg)
initialModel _ = 
    ({
        nums = nums
    }, Cmd.none)

view : Model -> Html Msg 
view model = 
    div [] [
        div [class "header"] [
            h1 [] [text "Testing" ] ]
        , galleryView model pics ["left", "border"] ["pic", "zoomable"]
        , galleryView model pics2 ["center"] ["pic"]
        , galleryView model pics3 ["right"] ["header", "pic"]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 5000 Tick


main : Program () Model Msg
main = 
    Browser.element
    {
        init = initialModel
        ,view = view
        ,update = update
        ,subscriptions = subscriptions
    }
