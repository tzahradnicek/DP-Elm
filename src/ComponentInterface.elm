port module ComponentInterface exposing (..)

import Dict exposing (Dict)
import Components.Gallery exposing(..)
import Components.Highlight exposing(..)
import Components.Grid exposing(..)
import PageElements exposing(..)
import Constants exposing(pics, pics3, pats, Comp)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time

type Msg
    = GalleryMessage Components.Gallery.Msg
    | HighlightMessage Components.Highlight.Msg
    | GridMessage Components.Grid.Msg
    | PageMsg PageElements.Msg
    | ScrollToElement String
    | ComponentIntMessage Msg


-- define which dictionaries to loop through using subscriptions
keysToUpdate : List (String, Int)
keysToUpdate =
    [ ("pics", Components.Gallery.dictSize pics), ("pics2", Components.Gallery.dictSize pics), ("pics3", Components.Gallery.dictSize pics3), ("pats", Components.Gallery.dictSize pats) ]

-- combined update for all incoming components to the interface
update : Msg -> Comp -> (Comp, Cmd Msg)
update msg model = 
    case msg of
        GalleryMessage message ->
            updateGallery GalleryMessage model ( Components.Gallery.update message model.nums keysToUpdate)
        HighlightMessage message ->
            updateHighlight HighlightMessage model ( Components.Highlight.update message model.highl)
        PageMsg message ->
            updateNavBar PageMsg model ( PageElements.update message model.currPage)
        ScrollToElement message ->
            (model, scrollToElement message)
        _ ->
            (model, Cmd.none)

-- mapping the component update functions to the component update function
updateGallery : (subMsg -> Msg) -> Comp -> ( Components.Gallery.Model, Cmd subMsg ) -> ( Comp, Cmd Msg )
updateGallery toMsg model ( subModel, subCmd ) =
    ( {model | nums = subModel}
    , Cmd.map toMsg subCmd
    )

updateHighlight : (subMsg -> Msg) -> Comp -> ( Components.Highlight.Model, Cmd subMsg ) -> ( Comp, Cmd Msg )
updateHighlight toMsg model ( subModel, subCmd ) =
    ( {model | highl = subModel}
    , Cmd.map toMsg subCmd
    )

updateNavBar : (subMsg -> Msg) -> Comp -> ( Components.Highlight.Model, Cmd subMsg ) -> ( Comp, Cmd Msg )
updateNavBar toMsg model ( subModel, subCmd ) =
    ( {model | currPage = subModel}
    , Cmd.map toMsg subCmd
    )


viewOne : Comp -> Html Msg 
viewOne model = 
    div [] [
        div [class "header"] [
            h1 [] [ text "Component Creation Patterns and Their Use in Elm"] 
            , Html.map PageMsg (navBarView model.currPage)
        ] 
        , Html.map PageMsg (homeBubbleView model.currPage "Home")
        , Html.map PageMsg (codingBubbleView model.currPage "About")
        , div [visibleClass model.currPage "About" "textcontainer"] [
            Html.map GalleryMessage (Components.Gallery.view model.nums pats ["left"] ["pic"])
        ] 
        -- , div [visibleClass model.currPage "Home" "textcontainer"] [
        --     Html.map GridMessage (Grid.gridView [["monkey.png", "slowmo"], ["donkey.png", "bright"], ["cat.png", "zoomable"]])
        -- ]
        , a [ onClick (ScrollToElement "top"), class "clickable"] [text "Back To Top"]
    ]

-- viewTwo : Model -> Html Msg 
-- viewTwo model = 
--     div [] [
--         Html.map PageMsg (bubbleView model.currPage)
--         -- , Html.map PageMsg (snippetView model.currPage "div [class 'myclass'] [\n text 'mytext'\n , button [class 'buttonclass'] []\n]")
--         , div [visibleClass model.currPage "Home" "textcontainer"] [
--             Html.map HighlightMessage (Highlight.view model.highl highlight)
--         ]
--         , a [ onClick (ScrollToElement "top"), class "clickable"] [text "Back To Top"]
--     ]

subscriptions : Comp -> Sub Msg
subscriptions model =
    Sub.map GalleryMessage (Time.every 5000 Tick)

port scrollToElement: String -> Cmd msg