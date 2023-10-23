port module Main exposing (main)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import ComponentInterface exposing(..)

type Msg
    = PageMsg PageMsg
    | ScrollToElement String
    | ComponentIntMessage ComponentInterface.Msg

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


view : Model -> Html Msg 
view model = 
    div [id "bodydiv"] [
        div [id "top"] []
        , div [class "header"] [
            h1 [] [ text "Práca s komponentmi v jazyku Elm"] 
            , navBarView model
            ] 
        , paragprahView model "Home" "first" "text for home\n pagasdsajgajdgbkajdbgk jadbgkjadbgkjadbgjbdgakjgbkadjgbkjdabgkjdabgk jdagbkadjgbadkjgbdakgjadg bkadjgbkjdagbkjadgbkadjgbkadjgbkadjgbkjadbgkjadbgkdj abgkjdabgkjadbgjkadbgkjadgbdkabgdajgbkadjgbkjadgb kajdgbkadjgbkadjgbkadjgbkadjgbgkjdabdgkaj bgdakjalfjlaskdje"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage2"
        , paragprahView model "Home" "second" "text for homepage3"
        , paragprahView model "About" "second" "text for about"
        , paragprahView model "Contact" "second" "text for contact"
        , snippetView model "div [class 'myclass'] [\n text 'mytext'\n , button [class 'buttonclass'] []\n]"
        , Html.map ComponentIntMessage (ComponentInterface.view model)
        -- , div [visibleClass model "Home" "textcontainer"] [
        --     Html.map GalleryMessage (Gallery.galleryView model.nums pics ["left", "border"] ["pic", "zoomable"])
        -- ]   
        , a [ onClick (ScrollToElement "top"), class "clickable"] [text "Back To Top"]
        -- , Html.map GalleryMessage (Gallery.galleryView model.nums pics ["left", "border"] ["pic", "zoomable"])
        -- , Html.map GalleryMessage (Gallery.galleryView model.nums pics2 ["center"] ["pic"])
        -- , Html.map GalleryMessage (Gallery.galleryView model.nums pics3 ["right"] ["header", "pic"])
        -- , Html.map HighlightMessage (Highlight.highlightView model.highl highlight)
        -- , Html.map GridMessage (Grid.gridView [["monkey.png", "slowmo"], ["donkey.png", "bright"], ["cat.png", "zoomable"]])
        ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        ComponentIntMessage message ->
            updateInterface ComponentIntMessage ( ComponentInterface.update message model)
        PageMsg message -> 
            navBarUpdate model message
        ScrollToElement message ->
            (model, scrollToElement message)

updateInterface : (subMsg -> Msg) -> ( ComponentInterface.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateInterface toMsg ( subModel, subCmd ) =
    ( subModel, Cmd.map toMsg subCmd)

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

componentSubcriptions : Model -> Sub Msg
componentSubcriptions model = 
    Sub.map ComponentIntMessage (ComponentInterface.subscriptions model)

port scrollToElement: String -> Cmd msg

main : Program () Model Msg
main = 
    Browser.element
    {
        init = initialModel
        ,view = view
        ,update = update
        ,subscriptions = componentSubcriptions
    }
