port module Main exposing (main)
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
    | PageMsg PageMsg
    | ScrollToElement String

type PageMsg 
    = Home
    | About
    | Contact

type alias Model = 
    {
        nums: Dict String Int
        ,highl: String
        ,currPage: String
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
        ,currPage = "Home"
    }, Cmd.none)

-- variable used in the update for all the gallery views that should be ticking automatically
keysToUpdate : List (String, Int)
keysToUpdate =
    [ ("pics", Gallery.dictSize pics), ("pics2", Gallery.dictSize pics), ("pics3", Gallery.dictSize pics3) ]

view : Model -> Html Msg 
view model = 
    div [id "bodydiv"] [
        div [id "top"] []
        , div [class "header"] [
            navBarView model
            , h1 [] [ text "Práca s komponentmi v jazyku Elm"] 
            ] 
        , paragprahView model "Home" "first" "text for homepagasdsajgajdgbkajdbgkjadbgkjadbgkjadbgjbdgakjgbkadjgbkjdabgkjdabgkjdagbkadjgbadkjgbdakgjadgbkadjgbkjdagbkjadgbkadjgbkadjgbkadjgbkjadbgkjadbgkdjabgkjdabgkjadbgjkadbgkjadgbdkabgdajgbkadjgbkjadgbkajdgbkadjgbkadjgbkadjgbkadjgbgkjdabdgkajbgdakjalfjlaskdje"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage3"
        , paragprahView model "About" "second" "text for about"
        , paragprahView model "Contact" "second" "text for contact"
        -- , div [visibleClass model "Home" ""] [
        --     Html.map GalleryMessage (Gallery.galleryView model.nums pics ["left", "border"] ["pic", "zoomable"])
        -- ]
        , paragprahView model "Home" "third" "text for contact"
        , a [ onClick (ScrollToElement "top"), class "clickable"] [text "Back To Top"]
        -- , Html.map GalleryMessage (Gallery.galleryView model.nums pics ["left", "border"] ["pic", "zoomable"])
        -- , Html.map GalleryMessage (Gallery.galleryView model.nums pics2 ["center"] ["pic"])
        -- , Html.map GalleryMessage (Gallery.galleryView model.nums pics3 ["right"] ["header", "pic"])
        -- , Html.map HighlightMessage (Highlight.highlightView model.highl highlight)
        -- , Html.map GridMessage (Grid.gridView [["monkey.png", "slowmo"], ["donkey.png", "bright"], ["cat.png", "zoomable"]])
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
        PageMsg message -> 
            navBarUpdate model message
        ScrollToElement message ->
            (model, scrollToElement message)
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

navBarView : Model -> Html Msg
navBarView model = 
    div [ class "navcontainer"] [
        ul [ class "navbar" ]
        [   
            Html.map PageMsg (navBarItem model "Home" Home)
            ,Html.map PageMsg (navBarItem model "About" About)
            ,Html.map PageMsg (navBarItem model "Contact" Contact)
        ]
    ]

navBarItem : Model -> String -> PageMsg -> Html PageMsg
navBarItem model label page = 
    let
        style = "clickable"
    in
        li [] [
            a [ (if model.currPage == label then
                class (String.concat [style, " active"] )
                else
                class style), onClick page] [ Html.text label ] ]

navBarUpdate : Model -> PageMsg -> (Model, Cmd Msg)
navBarUpdate model message = 
    case message of
        Home ->
            ( {model | currPage = "Home"}, Cmd.none)
        About -> 
            ( {model | currPage = "About"}, Cmd.none)
        Contact -> 
            ( {model | currPage = "Contact"}, Cmd.none)

visibleClass: Model -> String -> String -> Attribute msg
visibleClass model input userclass = 
    if model.currPage == input then
        class userclass
    else
        class (String.concat ["notvisible ", userclass])

paragprahView: Model -> String -> String -> String -> Html Msg
paragprahView model context elementID content = 
    div [visibleClass model context "textcontainer", id elementID] [
        text content
        ,br [] []
    ]

port scrollToElement: String -> Cmd msg

main : Program () Model Msg
main = 
    Browser.element
    {
        init = initialModel
        ,view = view
        ,update = update
        ,subscriptions = subscriptions
    }
