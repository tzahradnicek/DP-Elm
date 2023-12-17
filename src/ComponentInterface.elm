port module ComponentInterface exposing (..)

import Dict exposing (Dict)
import Gallery exposing(..)
import Highlight exposing(..)
import Grid exposing(..)
import PageElements exposing(..)
import Constants exposing(pics, pics2, pics3, highlight, Model)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time

type Msg
    = GalleryMessage Gallery.Msg
    | HighlightMessage Highlight.Msg
    | GridMessage Grid.Msg
    | PageMsg PageElements.Msg
    | ScrollToElement String
    | ComponentIntMessage Msg


-- define which dictionaries to loop through using subscriptions
keysToUpdate : List (String, Int)
keysToUpdate =
    [ ("pics", Gallery.dictSize pics), ("pics2", Gallery.dictSize pics), ("pics3", Gallery.dictSize pics3) ]

-- combined update for all incoming components to the interface
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        GalleryMessage message ->
            updateGallery GalleryMessage model ( Gallery.update message model.nums keysToUpdate)
        HighlightMessage message ->
            updateHighlight HighlightMessage model ( Highlight.update message model.highl)
        PageMsg message ->
            updateNavBar PageMsg model ( PageElements.update message model.currPage)
        ScrollToElement message ->
            (model, scrollToElement message)
        _ ->
            (model, Cmd.none)

-- mapping the component update functions to the component update function
updateGallery : (subMsg -> Msg) -> Model -> ( Gallery.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateGallery toMsg model ( subModel, subCmd ) =
    ( {model | nums = subModel}
    , Cmd.map toMsg subCmd
    )

updateHighlight : (subMsg -> Msg) -> Model -> ( Highlight.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateHighlight toMsg model ( subModel, subCmd ) =
    ( {model | highl = subModel}
    , Cmd.map toMsg subCmd
    )

updateNavBar : (subMsg -> Msg) -> Model -> ( Highlight.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateNavBar toMsg model ( subModel, subCmd ) =
    ( {model | currPage = subModel}
    , Cmd.map toMsg subCmd
    )


viewOne : Model -> Html Msg 
viewOne model = 
    div [] [
        div [class "header"] [
            h1 [] [ text "Práca s komponentmi v jazyku Elm"] 
            , Html.map PageMsg (navBarView model.currPage)
        ] 
        , Html.map PageMsg (bubbleView model.currPage)
        , Html.map PageMsg (snippetView model.currPage "div [class 'myclass'] [\n text 'mytext'\n , button [class 'buttonclass'] []\n]")
        , div [visibleClass model.currPage "Home" "textcontainer"] [
            Html.map GalleryMessage (Gallery.view model.nums pics ["left", "border"] ["pic", "zoomable"])
        ] 
        , div [visibleClass model.currPage "Home" "textcontainer"] [
            Html.map GridMessage (Grid.gridView [["monkey.png", "slowmo"], ["donkey.png", "bright"], ["cat.png", "zoomable"]])
        ]
    ]

viewTwo : Model -> Html Msg 
viewTwo model = 
    div [] [
        Html.map PageMsg (bubbleView model.currPage)
        , Html.map PageMsg (snippetView model.currPage "div [class 'myclass'] [\n text 'mytext'\n , button [class 'buttonclass'] []\n]")
        , div [visibleClass model.currPage "Home" "textcontainer"] [
            Html.map HighlightMessage (Highlight.view model.highl highlight)
        ]
        , a [ onClick (ScrollToElement "top"), class "clickable"] [text "Back To Top"]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map GalleryMessage (Time.every 1000 Tick)

port scrollToElement: String -> Cmd msg