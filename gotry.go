package main

import (
    "fmt"
    // "log"
    "net/http"
    "os" 
    "github.com/go-martini/martini"
    "github.com/gin-gonic/gin"
)

func main() {
    // logFile := "testlogfile"
    port := "3001"
    if os.Getenv("HTTP_PLATFORM_PORT") != "" {
        // logFile = "D:\\home\\site\\wwwroot\\testlogfile"
        port = os.Getenv("HTTP_PLATFORM_PORT")
    }

    // f, err := os.OpenFile(logFile, os.O_RDWR | os.O_CREATE | os.O_APPEND, 0666)
           
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        // fmt.Fprintf(w, "Hello form Go! Error: %v", err)
        fmt.Fprintf(w, `
        <html>
            <body>
                <h1>Hello from Go!</h1>
                <br />
                <a href='/g'>Try Gin</a>
                <br />
                <a href='/m'>Try Martini</a>
            </body>
        </html>`)
    })
    
/*    
    if err != nil {
        http.ListenAndServe(":"+port, nil)
    } else {
         defer f.Close()
         log.SetOutput(f)
         log.Println("--->   UP @ " + port +"  <------")
    }
*/

    m := martini.Classic()
    m.Get("/m/", func() string {
      return `
        <html>
            <body>
                <h1>Hello from Martini!</h1>
                <br />
                <a href='/'>Home</a>
                <br />
                <a href='//github.com/go-martini/martini' target='_blank'>Martini @ Github</a>
            </body>
        </html>`;
    })
    // m.Map(log.New(f, "[martini]", log.LstdFlags))    
    http.Handle("/m/", m)

    g := gin.Default()
    g.GET("/g/", func(c *gin.Context) {
        c.HTMLString(http.StatusOK, `
        <html>
            <body>
                <h1>Hello from Gin!</h1>
                <br />
                <a href='/'>Home</a>
                <br />
                <a href='//github.com/gin-gonic/gin' target='_blank'>Gin @ Github</a>
            </body>
        </html>`)
    })
    http.Handle("/g/", g)
    
    http.ListenAndServe(":"+port, nil)
}

