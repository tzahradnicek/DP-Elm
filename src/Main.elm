module Main exposing (main)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Gallery exposing(..)
import Highlight exposing(..)
import Grid exposing(..)
import Files exposing(pics, pics2, pics3, highlight)
import Time

type Msg
    = GalleryMessage Gallery.Msg
    | HighlightMessage Highlight.Msg
    | GridMessage Grid.Msg

type alias Model = 
    {
        nums: Dict String Int
        ,highl: String
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
        ,highl = "two"
    }, Cmd.none)

-- variable used in the update for all the gallery views that should be ticking automatically
keysToUpdate : List (String, Int)
keysToUpdate =
    [ ("pics", Gallery.dictSize pics), ("pics2", Gallery.dictSize pics), ("pics3", Gallery.dictSize pics3) ]

view : Model -> Html Msg 
view model = 
    div [] [
        div [class "header"] [
            h1 [] [text "Testing" ] ]
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics ["left", "border"] ["pic", "zoomable"])
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics2 ["center"] ["pic"])
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics3 ["right"] ["header", "pic"])
        , Html.map HighlightMessage (Highlight.highlightView model.highl highlight)
        , Html.map GridMessage (Grid.gridView [["monkey.png", "slowmo"], ["donkey.png", "bright"], ["cat.png", "zoomable"]])
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map GalleryMessage (Time.every 1000 Tick)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        GalleryMessage message ->
            updateWith GalleryMessage model ( Gallery.update message model.nums keysToUpdate)
        HighlightMessage message ->
            updateWithHighl HighlightMessage model ( Highlight.update message model.highl)
        _ ->
            (model, Cmd.none)

updateWith : (subMsg -> Msg) -> Model -> ( Gallery.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toMsg model ( subModel, subCmd ) =
    ( {model | nums = subModel}
    , Cmd.map toMsg subCmd
    )

updateWithHighl : (subMsg -> Msg) -> Model -> ( Highlight.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWithHighl toMsg model ( subModel, subCmd ) =
    ( {model | highl = subModel}
    , Cmd.map toMsg subCmd
    )

main : Program () Model Msg
main = 
    Browser.element
    {
        init = initialModel
        ,view = view
        ,update = update
        ,subscriptions = subscriptions
    }
