module ComponentInterface exposing (updateWith, updateWithHighl)

import Dict exposing (Dict)
import Gallery exposing(..)
import Highlight exposing(..)

type alias Model = 
    {
        nums: Dict String Int
        ,count: Int
        ,highl: String
    }

type Msg
    = GalleryMessage Gallery.Msg
    | HighlightMessage Highlight.Msg


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