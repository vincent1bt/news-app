##News App
App para iOS donde puedes buscar noticias en twitter o the new york times.

##Descripción

![News App](http://res.cloudinary.com/vincent1bt/image/upload/v1462570588/newsApp_c6twv6.gif "Video demo")


##Api

1. Api de new york times
2. Api de twitter

##Uso

Necesitan crear una app de [Twitter](https://apps.twitter.com)
con la siguiente configuración:

- Access level: Read and write
- Sign in with Twitter:	Yes

Despues crear un nuevo archivo tipo swift(vacio) llamado Keys.swift (el nombre puede ser el que ustedes quieran)
que tenga el siguiente codigo:

```
import Foundation

struct Keys {
  struct Twitter {
    static let consumerKey: String = "consumerKey"
    static let secretKey: String = "secretKey"
  }
}
```