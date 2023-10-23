module ComponentInterface exposing (..)

import Dict exposing (Dict)
import Gallery exposing(..)
import Highlight exposing(..)
import Grid exposing(..)
import Files exposing(pics, pics2, pics3, highlight)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time


type alias Model = 
    {
        nums: Dict String Int
        ,highl: String
        ,currPage: String
    }

type Msg
    = GalleryMessage Gallery.Msg
    | HighlightMessage Highlight.Msg
    | GridMessage Grid.Msg
    | PageMsg PageMsg
    | ScrollToElement String
    | ComponentIntMessage Msg

type PageMsg 
    = Home
    | About
    | Contact

keysToUpdate : List (String, Int)
keysToUpdate =
    [ ("pics", Gallery.dictSize pics), ("pics2", Gallery.dictSize pics), ("pics3", Gallery.dictSize pics3) ]

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


view : Model -> Html Msg 
view model = 
    div [] [
        Html.map GalleryMessage (Gallery.galleryView model.nums pics ["left", "border"] ["pic", "zoomable"])
        , Html.map HighlightMessage (Highlight.highlightView model.highl highlight)
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map GalleryMessage (Time.every 1000 Tick)