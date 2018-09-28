module Route exposing (Route(..), fromUrl, href, replaceUrl, toString)

import Admin.Route as Admin
import Browser.Navigation as Navigation
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attributes
import Trainer.Route as Trainer
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, s)


type Route
    = NotFound
    | Index
    | Admin Admin.Route
    | Trainer Trainer.Route


routeParser : Parser (Route -> subRoute) subRoute
routeParser =
    Parser.oneOf
        [ Parser.map Index (s "")
        , Parser.map Admin Admin.routeParser
        , Parser.map Trainer Trainer.routeParser
        ]


toString : Route -> String
toString route =
    case route of
        NotFound ->
            "/404"

        Index ->
            "/"

        Admin adminRoute ->
            Admin.toString adminRoute

        Trainer trainerRoute ->
            Trainer.toString trainerRoute


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse routeParser


href : Route -> Attribute msg
href targetRoute =
    Attributes.href (toString targetRoute)


replaceUrl : Navigation.Key -> Route -> Cmd msg
replaceUrl key route =
    Navigation.replaceUrl key (toString route)