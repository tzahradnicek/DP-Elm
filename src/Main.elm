module Main exposing (main)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import ComponentInterface exposing(..)
import Constants exposing (Model, nums)

type Msg
    = ComponentIntMessage ComponentInterface.Msg

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
        , Html.map ComponentIntMessage (ComponentInterface.viewOne model)
        , Html.map ComponentIntMessage (ComponentInterface.viewTwo model)
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        ComponentIntMessage message ->
            updateInterface ComponentIntMessage ( ComponentInterface.update message model)

-- mapping the combined update function from the component interface
updateInterface : (subMsg -> Msg) -> ( Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateInterface toMsg ( subModel, subCmd ) =
    ( subModel, Cmd.map toMsg subCmd)

-- subscription mapping function from the component interface
componentSubcriptions : Model -> Sub Msg
componentSubcriptions model = 
    Sub.map ComponentIntMessage (ComponentInterface.subscriptions model)

main : Program () Model Msg
main = 
    Browser.element
    {
        init = initialModel
        ,view = view
        ,update = update
        ,subscriptions = componentSubcriptions
    }
