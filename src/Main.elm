module Main exposing (main)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Gallery exposing(..)
import Files exposing(pics, pics2, pics3)
import Time

type Msg
    = Plus
    | Minus
    | GalleryMessage Gallery.Msg

type alias Model = 
    {
        nums: Dict String Int
        ,count: Int
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
        ,count = 1
    }, Cmd.none)

view : Model -> Html Msg 
view model = 
    div [] [
        div [class "header"] [
            h1 [] [text "Testing" ] ]
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics ["left", "border"] ["pic", "zoomable"])
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics2 ["center"] ["pic"])
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics3 ["right"] ["header", "pic"])
        , text (Debug.toString model.count)
        , button [ onClick Plus ] [ text "+" ]
        , button [ onClick Minus ] [ text "-" ]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map GalleryMessage (Time.every 1000 Tick)
    -- Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        GalleryMessage message ->
            updateWith GalleryMessage model ( Gallery.update message model.nums )
        Plus -> 
            ({model | count = model.count + 1}, Cmd.none)
        Minus ->
            ({model | count = model.count - 1}, Cmd.none)

updateWith : (subMsg -> Msg) -> Model -> ( Gallery.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toMsg model ( subModel, subCmd ) =
    ( {model | nums = subModel}
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
