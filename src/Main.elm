module Main exposing (main, update)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ComponentInterface exposing(..)
import Constants exposing (Model, nums, Comp)

type Msg
    = ComponentIntMessage ComponentInterface.Msg

initialModel : () -> (Model, Cmd Msg)
initialModel _ = 
    ({
        components = {
            nums = nums
            ,highl = "two"
            ,currPage = "Home"
        }
    }, Cmd.none)


view : Model -> Html Msg 
view model = 
    div [id "bodydiv"] [
        div [id "top"] []
        , Html.map ComponentIntMessage (ComponentInterface.viewOne model.components)
        -- , Html.map ComponentIntMessage (ComponentInterface.viewTwo model)
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        ComponentIntMessage message ->
            updateInterface ComponentIntMessage model ( ComponentInterface.update message model.components)

-- mapping the combined update function from the component interface
updateInterface : (subMsg -> Msg) -> Model -> ( Comp, Cmd subMsg ) -> ( Model, Cmd Msg )
updateInterface toMsg model ( subModel, subCmd ) =
    ( {model | components = subModel}
    , Cmd.map toMsg subCmd
    )

-- subscription mapping function from the component interface
componentSubcriptions : Model -> Sub Msg
componentSubcriptions model = 
    Sub.map ComponentIntMessage (ComponentInterface.subscriptions model.components)

main : Program () Model Msg
main = 
    Browser.element
    {
        init = initialModel
        ,view = view
        ,update = update
        ,subscriptions = componentSubcriptions
    }
