type ultimateExpress

@module("ultimate-express")
external ultimateExpress: unit => ultimateExpress = "default"

type req
type res

type middleware = (req, res, unit => unit) => unit
type middlewareWithError = (Js.Exn.t, req, res, unit => unit) => unit
type handler = (req, res) => unit

external asMiddleware: ultimateExpress => middleware = "%identity"

// The *Middleware suffixes aren't really nice but avoids forcing people to disable warning 44
@module("ultimate-express") external jsonMiddleware: unit => middleware = "json"
@module("ultimate-express") external jsonMiddlewareWithOptions: {..} => middleware = "json"
@module("ultimate-express") external rawMiddleware: unit => middleware = "raw"
@module("ultimate-express") external rawMiddlewareWithOptions: {..} => middleware = "raw"
@module("ultimate-express") external textMiddleware: unit => middleware = "text"
@module("ultimate-express") external textMiddlewareWithOptions: {..} => middleware = "text"
@module("ultimate-express")
external urlencodedMiddleware: unit => middleware = "urlencoded"
@module("ultimate-express")
external urlencodedMiddlewareWithOptions: {..} => middleware = "urlencoded"
@module("ultimate-express") external staticMiddleware: string => middleware = "static"
@module("ultimate-express")
external staticMiddlewareWithOptions: (string, {..}) => middleware = "static"

@send external use: (ultimateExpress, middleware) => unit = "use"
@send external useWithPath: (ultimateExpress, string, middleware) => unit = "use"

@send external useWithError: (ultimateExpress, middlewareWithError) => unit = "use"
@send external useWithPathAndError: (ultimateExpress, string, middlewareWithError) => unit = "use"

@send external get: (ultimateExpress, string, handler) => unit = "get"
@send external post: (ultimateExpress, string, handler) => unit = "post"
@send external delete: (ultimateExpress, string, handler) => unit = "delete"
@deprecated("Express 5.0 deprecates app.del(), use app.delete() instead")
@send external del: (ultimateExpress, string, handler) => unit = "del"
@send external patch: (ultimateExpress, string, handler) => unit = "patch"
@send external put: (ultimateExpress, string, handler) => unit = "put"
@send external all: (ultimateExpress, string, handler) => unit = "all"

@send external enable: (ultimateExpress, string) => unit = "enable"
@send external enabled: (ultimateExpress, string) => bool = "enabled"
@send external disable: (ultimateExpress, string) => unit = "disable"

type server

@send external listen: (ultimateExpress, int) => server = "listen"
@send
external listenWithCallback: (ultimateExpress, int, option<Js.Exn.t> => unit) => server = "listen"
@send
external listenWithHostAndCallback: (
  ultimateExpress,
  ~port: int,
  ~host: string,
  option<Js.Exn.t> => unit,
) => server = "listen"

type method = [#GET | #POST | #PUT | #DELETE | #PATCH]

// req properties
@get external baseUrl: req => string = "baseUrl"
@get external body: req => 'a = "body"
@get external cookies: req => 'a = "cookies"
@get external fresh: req => bool = "fresh"
@get external hostname: req => string = "hostname"
@get external ip: req => string = "ip"
@get external ips: req => array<string> = "ips"
@get external method: req => method = "method"
@get external originalUrl: req => string = "originalUrl"
@get external params: req => 'a = "params"
@get external path: req => string = "path"
@get external protocol: req => string = "protocol"
@get external query: req => 'a = "query"
@get external route: req => 'a = "route"
@get external secure: req => bool = "secure"
@get external signedCookies: req => 'a = "signedCookies"
@get external stale: req => bool = "stale"
@get external subdomains: req => array<string> = "subdomains"
@get external xhr: req => bool = "xhr"

// This is a bit unfortunate, as it breaks the zero-cost philosophy,
// but the `string | false` signature doesn't play well with an ML type-system
external asString: 'a => string = "%identity"
let parseValue = value =>
  switch Js.typeof(value) {
  | "boolean" => None
  | _ => Some(value->asString)
  }

// req methods
@send external accepts: (req, array<string>) => 'a = "accepts"
@send external acceptsCharset: (req, array<string>) => 'a = "acceptsCharset"
@send external acceptsEncodings: (req, array<string>) => 'a = "acceptsEncodings"
@send external acceptsLanguages: (req, array<string>) => 'a = "acceptsLanguages"

let accepts = (req, value) => req->accepts(value)->parseValue
let acceptsCharset = (req, value) => req->acceptsCharset(value)->parseValue
let acceptsEncodings = (req, value) => req->acceptsEncodings(value)->parseValue
let acceptsLanguages = (req, value) => req->acceptsLanguages(value)->parseValue

@send external getRequestHeader: (req, string) => option<string> = "get"
@send external is: (req, string) => 'a = "is"

let is = (req, value) => req->is(value)->parseValue

@send external param: (req, string) => option<string> = "param"

// res properties
@get external headersSent: res => bool = "headersSent"
@get external locals: res => {..} = "locals"

// res methods
@send external append: (res, string, string) => res = "append"
@send external attachment: (res, ~filename: string=?) => res = "attachment"
@send external cookie: (res, ~name: string, ~value: string) => res = "cookie"
@send external cookieWithOptions: (res, ~name: string, ~value: string, {..}) => res = "cookie"
@send external clearCookie: (res, string) => res = "clearCookie"
@send external download: (res, ~path: string) => res = "download"
@send external downloadWithFilename: (res, ~path: string, ~filename: string) => res = "download"
@send external end: res => res = "end"
@send external endWithData: (res, 'a) => res = "end"
@send external endWithDataAndEncoding: (res, 'a, ~encoding: string) => res = "end"
@send external format: (res, {..}) => res = "format"
@send external getResponseHeader: (res, string) => option<string> = "get"
@send external json: (res, 'a) => res = "json"
@send external jsonp: (res, 'a) => res = "jsonp"
@send external links: (res, Js.Dict.t<string>) => res = "links"
@send external location: (res, string) => res = "location"
@send external redirect: (res, string) => res = "redirect"
@send external redirectWithStatusCode: (res, ~statusCode: int, string) => res = "redirect"
@send external send: (res, 'a) => res = "send"
@send external sendFile: (res, string) => res = "sendFile"
@send external sendFileWithOptions: (res, string, {..}) => res = "sendFile"
@send external sendStatus: (res, int) => res = "sendStatus"
@send external set: (res, string, string) => unit = "set"
@send external status: (res, int) => res = "status"
@send external \"type": (res, string) => string = "type"
@send external vary: (res, string) => res = "vary"

module Router = {
  type t
  @module("ultimate-express") external make: unit => t = "Router"
  @send external use: (t, middleware) => unit = "use"
  @send external useWithPath: (t, string, middleware) => unit = "use"

  @send external useWithError: (t, middlewareWithError) => unit = "use"
  @send external useWithPathAndError: (t, string, middlewareWithError) => unit = "use"

  @send external get: (t, string, handler) => unit = "get"
  @send external post: (t, string, handler) => unit = "post"
  @send external delete: (t, string, handler) => unit = "delete"
  @deprecated("Express 5.0 deprecates app.del(), use app.delete() instead")
  @send external del: (t, string, handler) => unit = "del"
  @send external patch: (t, string, handler) => unit = "patch"
  @send external put: (t, string, handler) => unit = "put"
  @send external all: (t, string, handler) => unit = "all"

  type paramHandler = (req, res, unit => unit, string, string) => unit

  @send external param: (t, string, paramHandler) => unit = "param"
  @deprecated("deprecated as of v4.11.0")
  @send external defineParamBehavior: ((string, 'a) => paramHandler) => unit = "param"

  @send external route: string => t = "route"
}

@send external useRouter: (ultimateExpress, Router.t) => unit = "use"
@send external useRouterWithPath: (ultimateExpress, string, Router.t) => unit = "use"
