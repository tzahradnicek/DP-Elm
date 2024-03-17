module PageElements exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias Model = String

type Msg 
    = Home
    | About
    | Contact

update : Msg -> Model -> (Model, Cmd Msg)
update message model = 
    case message of
        Home ->
            ( "Home", Cmd.none)
        About -> 
            ( "About", Cmd.none)
        Contact -> 
            ( "Contact", Cmd.none)

-- isolated collection of bubbles inside the component, rather than cluttering the component interface with a handful of these lines
homeBubbleView: Model -> String -> Html Msg
homeBubbleView model context =
    div [ visibleClass model context "" ] [
        paragprahView model "" "Viability of Components in Elm" "Elm is a functional language that compiles to JavaScript. It helps you make websites and web apps. It has a strong emphasis on simplicity and quality tooling. As every functional programming language it has its strengths such as no run-time errors in practice, friendly error messages, reliable refactoring. With these attributes also comes great reliability, maintainability and performance in the context of front-end web development. As the official Elm guide reads: „No combination of JS libraries can give you all of these guarantees. They come from the design of the language itself! And thanks to these guarantees, it is quite common for Elm programmers to say they never felt so confident while programming. Confident to add features quickly. Confident to refactor thousands of lines.“ However, this website/tutorial would not exist if Elm did not have some smaller issues and irregularities. To be more specific, we are going to look at components and their state in Elm. The official guide for the structure of Elm states the following: „Folks coming from JavaScript tend to bring habits, expectations, and anxieties that are specific to JavaScript. They are legitimately important in that context, but they can cause some pretty severe troubles when transferred to Elm.“ Now, this claim can not be denied, as components among many other coding principles have proven to be useful and widely used - let it be in JavaScript, React or any other popular programming language. We mention JavaScript and React specifically because they are mostly used to develop user interaction heavy web applications. To dig a bit deeper into this topic, lets see what the official guide for the structure of Elm has to say about using components in Elm: „Folks coming from React expect everything to be components. Actively trying to make components is a recipe for disaster in Elm. The root issue is that components are objects.“ The guide further elaborates on this, using a simple example where a developer would implement a simple sidebar element - which would be done as a component in JavaScript or React: „It would be way easier to just make a viewSidebar function and pass it whatever arguments it needs. It probably does not even have any state. Maybe one or two fields? Just put it in the Model you already have. Point is, writing a viewSidebar function does not mean you need to create a corresponding update and Model to go with it. Resist this instinct. Just write the helper functions you need.“"
        , paragprahView model "" "The First Steps" """While I do agree with this to some extent, I wanted to explore the possibilities of components in Elm. To be more specific, my goal was to try what can and cannot be done using components in Elm, while the final outcome was a set of architectural patterns. These patterns are supposed to be guides allowing developers to try and use components in Elm. In theory, any pattern that would come out of my research could be considered as an anti-pattern to what we saw in the official Elm guide. On the other hand, if any of the patterns would prove to be useful, providing a clean and efficient way to use components in Elm, the official Elm guide be considered as the anti-pattern. Which will be the case will depend on how well will my patterns be received, tested and evaluated by other developers. Here is what I found and a step by step explanation to how and why I came up with my patterns. As I had no previous experience with Elm nor with any functional programming language the first steps were to get comfortable with the syntax, types and Elm itself. My first task was to make a simple site with which the user could interact. My second task was to implement a more complex element that could be worthy for its own module. The first component I chose was an image gallery/slideshow, which is simple but can be improved and made more complex - which is exactly what I needed in the long term. I implemented the gallery component in the following iterations: get the image to show up on the website, learn how to use messages and the update function in Elm properly, figure out a way to feed my images to the gallery(using Dict, which was more complex and a lot different than I thought it would be), find a way how to make the images cycle using buttons, implement subscriptions so the images will cycle automatically"""
        , paragprahView model "" "Creating The First Component" """At first the official Elm guide had a fair point, where it was clear that components such as my gallery can be done using just helper functions without a module of their own. But that’s just one component, with one basic functionality. I looked at the code I wrote, and it was around 150 lines of code (not clean and optimized of course) for my component and some very basic HTML elements like a header and some divisions. This made me realize that while I did implement a component with only helper functions I forgot about clean, maintainable and reusable code. I had all of the interactions and inputs into my gallery hard-coded which would prevent me to reuse my code. This, of course, was an issue on my side. To correct these issues I put the component’s definition into a helper view function and all of the interactions into its own update function. This was where my "JavaScript instincts"kicked in and I decided to take my component and put it into a module/file of its own. With this simple change, my code seemed to be cleaner but it still worked. There was one major issue, as I had no other elements on my website other than the image gallery I was able to use the update function of my component - as I look back was definitely mistake, which had to be made to learn and make the code better/cleaner and the usage of components in Elm more approachable. To implement the use case of my gallery component correctly I had to do some research on how to make view and update functions from another module work in my main file. The usual "just import it and use it"JavaScript approach did not work, as there were problems with the types of the messages that the component’s view and update function were producing. Even though both function had the same type annotation as the view and update function in my main file, the types were not compatible. This was due to the fact that the component’s view a update functions were producing Gallery.Html Msg instead of Html Msg. Each function had to be fixed separately - the view function had to be mapped using the GalleryMessage message type and the Html.map function. As for the update function, at first the task seemed to be impossible with the amount of knowledge I had when I faced the problem. The idea was almost the same as it was with the view function - take the component’s update function and convert it/it’s results so they are compatible with the main file’s type. One might consider just undoing the step where we moved the gallery component outside of the main file to not have to deal with this issue. I wanted to continue, to see if the usage of components is really as bad in Elm as it seems/as the official guide claims it to be. The solution for this problem was finally found in the source code for a Single Page Application (SPA) example from Richard Feldman’s github page [0]. After this discovery, we made a simpler version of Feldman’s updateWith function, which we started using to map the update function of the gallery component with."""
        , snippetView model "" "The solution for the view function looks like the following:" """import Gallery exposing(..)

type Msg
    = GalleryMessage Gallery.Msg

view : Model -> Html Msg 
view model = 
    div [] [
        div [class "header"] [
            h1 [] [text "My first page" ] ]
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics2 ["center"] ["pic"])
        ]"""
        , snippetView model "" "The simplified version of the updateWith function in action:" """update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        GalleryMessage message ->
            updateWith GalleryMessage model ( Gallery.update message model.nums )

updateWith : (subMsg -> Msg) -> Model -> ( Gallery.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toMsg model ( subModel, subCmd ) =
    ( {model | nums = subModel}
    , Cmd.map toMsg subCmd
    )"""
        , paragprahViewNoT model "" """Our updateWith function is mapping the output of the gallery component’s update function to the correct type which is compatible and acceptable for the main file. This is done using the message type which the gallery component generates, its model and command. The gallery component’s model is basically just a field, which acts as a local state for it. This local model is then replaced in the main model, thus the need of the updateWith function. After these changes my component was working as intended, with functional user interactions and automatic picture cycling using subscriptions. There were a few things left which had to be done to make the component more dynamic - the way how arguments are passed into the component and some styling. This may and most probably will vary with each component, but in my case I wanted to make it more customizable from the outside - to reuse the component without any changes to the component’s source code itself."""
    ]

codingBubbleView: Model -> String -> Html Msg
codingBubbleView model context =
    div [ visibleClass model context "" ] [
        paragprahView model "" "Some More Components" """The successful implementation of the updateWith function lead me to find and add a new component to my website. This time, the choice landed on a similar component which used images as its main point of attraction with a small amount of user interaction. The component is a tab gallery which would highlight the selected image - my Highlight component. The process of implementation was similar to the gallery component’s, but this time it was faster and easier. This was due to the fact that most of what I used for my first component could be used for this one as well. The biggest advantage was my previous experience with the mapping functions that were used before."""
         , snippetView model "" "After implementing my Highlight component and moving it into its own module the code looked something like this:" """update : import Gallery exposing(..)
import Highlight exposing(..)

type Msg
    = GalleryMessage Gallery.Msg
    | HighlightMessage Highlight.Msg

view model = 
    div [] [
        div [class "header"] [
            h1 [] [text "Testing" ] ]
        , Html.map GalleryMessage (Gallery.galleryView model.nums pics2 ["center"] ["pic"])
        , Html.map HighlightMessage (Highlight.highlightView model.highl highlight)
        ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        GalleryMessage message ->
            updateWith GalleryMessage model ( Gallery.update message model.nums )
        HighlightMessage message ->
            updateWithHighl HighlightMessage model ( Highlight.update message model.highl)  

updateWith : (subMsg -> Msg) -> Model -> ( Gallery.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toMsg model ( subModel, subCmd ) =
    ( {model | nums = subModel}
    , Cmd.map toMsg subCmd
    )

updateWithHighl : (subMsg -> Msg) -> Model -> ( Highlight.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWithHighl toMsg model ( subModel, subCmd ) =
    ( {model | highl = subModel}
    , Cmd.map toMsg subCmd
    )"""
    , snippetView model "" """As one might have noticed, the amount of code added into the main file is not too extensive. A few lines of code for imports, message and model declarations, adding the Highlight component into the main view and update functions and lastly making a new updateWithHighl function, which is a slightly altered version of the previous one. The changes made to the updateWith are specific to the new highlight component. At this point I realized that each component will need an updateWith function in case the component has its own update function. To test this theory I decided to implement another component, which was meant to be static with no user interactions - without an update function. Since I already had two components that revolved around images, I decided to implement a simple image grid. Adding the image grid component (of course after encapsulating it into its own module) was even easier than the previous ones, as my theory was proven to be true. To add the image grid component, I only needed to add the import and message declaration along with adding the component’s view into the main file’s view function. The update function of the main file was also slightly changed, just to account for the image grid’s message type - which does not do anything anyways.""" """update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        GalleryMessage message ->
            updateWith GalleryMessage model ( Gallery.update message model.nums )
        HighlightMessage message ->
            updateWithHighl HighlightMessage model ( Highlight.update message model.highl)  
         _ ->
            (model, Cmd.none)"""
    , paragprahViewList model "" "At this point I considered the first pattern to be done." "Once I implemented all three components and defined my first pattern, it was apparent that simply encapsulating the components one by one or grouping them into one file - as one prefers - might not be clean and good enough. The reason behind this thought was the fact that each newly created type of component (two gallery components can use the same update and updateWith function) would require me to implement its own updateWith function along with all the required lines of code (10+ in its current state). The number of lines of code would not be problem, my main issue was the fact that the main file would get cluttered with helper functions that were needed for the components." ["Implement the component", "Encapsulate it into its own file/module", "Implement an updateWith function so it can be mapped", "Import the component into the main file", "Map the view and update functions so the component can be used"] 
    , paragprahView model "" "The Component Interface" "A possible solution for this issue was hidden in plain sight, in the paragraph above. As I wrote above, one might want to group the definitions of some components into one file. But what if instead of doing that, one would combine/collect the usage of all components into one file with its shared view and update functions? I called this the ComponentInterface, where I would place all the code using components shown above. The idea was to not clutter the main file with all the definitions related to components, while still using components in an efficient way. My ComponentInterface looked like a promising way to achieve this goal. One problem came up while implementing this idea though - each component has its own file and now on top of that, there was another file that was supposed to collect all the components. This implied the need of yet another updateWith, which seemed to be a bit tedious at this point. There was one difference in the new updateWith function, this one was supposed to serve the whole ComponentInterface, including all the components that are being used inside of it, which means that using this approach there would be only one updateWith function in the main file per ComponentInterface. With these changes the main file could be cleaned up by moving all code needed to use the components into the ComponentInterface itself. The main file would then get a new set of exactly eight lines of code, to import and use the ComponentInterface. This number of lines would not change with the increasing number of components inside of the ComponentInterface which means that the code in the main file can be kept clean regardless of what’s happening in the ComponentInterface itself. For this to work, we had to move the model from the main file to the constants file, as the both the main file and the ComponnetInterface need to have access to the model."
    , snippetView model "" "The model is still only being changed in the main file. Let’s look at the code in the main file after making these changes:" """import CompInterface exposing(..)

type Msg
    = ComponentIntMessage CompInterface.Msg

view model = 
    div [] [
        div [class "header"] [
            h1 [] [text "Testing" ] ]
        , Html.map ComponentIntMessage (CompInterface.view model)
        ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        ComponentIntMessage message ->
            updateInterface ComponentIntMessage ( CompInterface.update message model) 

updateInterface : (subMsg -> Msg) -> ( CompInterface.Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateInterface toMsg ( subModel, subCmd ) =
    ( subModel, Cmd.map toMsg subCmd)"""
    , paragprahViewList model "" "Implementing and realizing the idea of the ComponentInterface was a success and achieved the cleanup that was needed for the main file. Although the ComponentInterface on the inside might not seem to be as organized or clean, its only purpose is to collect components and to distribute them further to other files without the need to redefine the usage of each component along with their helper functions all over again. The success of the ComponentInterface lead me to define a second pattern:" "We will analyze and explain each of the patterns and their use cases further on the Patterns tab." ["Implement a component", "Encapsulate it into its own file/module", "Implement an updateWith function so it can be mapped", "Import the component into the ComponentInterface", "Repeat steps 1-4 for each new component", "Import the ComponentInterface into the main file", "Implement an updateWith function so the interface can be mapped", "Map the view and update functions of the interface so the components can be used"]
    ]

-- paragraph = bubble
paragprahView: Model -> String -> String -> String -> Html Msg
paragprahView model elementID title content = 
    div [] [
        div [ class "paragraphTitle" ] [
            h2 [] [ text title ]
        ]
        , div [ id elementID, class "paragraph textcontainer" ] [
            text content
        ]
    ]


paragprahViewNoT: Model -> String -> String -> Html Msg
paragprahViewNoT model elementID content = 
    div [] [
        div [ id elementID, class "paragraph textcontainer" ] [
            text content
        ]
    ]


paragprahViewList: Model -> String -> String -> String -> List (String) -> Html Msg
paragprahViewList model elementID content1 content2 listElems = 
    div [] [
        div [ id elementID, class "paragraph textcontainer" ] [
            text content1
            , ol [] (List.map (\item -> li [] [text item]) listElems)
            , text content2
        ]
    ]

-- code snippet
snippetView: Model -> String -> String -> String -> Html Msg
snippetView model elementID content codesnippet =
     div [class "textcontainer", id elementID] [
        text content
        , pre [] [
            code [class "language-elm line-numbers line-highlight"] [
                text codesnippet
            ]
        ]
    ]

-- the nav bar component views
navBarView : Model -> Html Msg
navBarView model = 
    div [ class "navcontainer"] [
        ul [ class "navbar" ]
        [   
            navBarItem model "Home" Home
            , navBarItem model "About" About
            , navBarItem model "Contact" Contact
        ]
    ]

navBarItem : Model -> String -> Msg -> Html Msg
navBarItem model label page = 
    let
        style = "clickable"
    in
        li [ class "navListEl"] [
            a [ (if model == label then
                class (String.concat [style, " active"] )
                else
                class style), onClick page] [ Html.text label ] ]

-- helper function to hide/show text bubbles depending on currPage from the model
visibleClass: Model -> String -> String -> Attribute msg
visibleClass model input userclass = 
    if model == input then
        class userclass
    else
        class (String.concat ["notvisible ", userclass])
