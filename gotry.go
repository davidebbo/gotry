package main

import (
    "fmt"
    "log"
    "net/http"
    "os" 
    "github.com/go-martini/martini"
    "github.com/gin-gonic/gin"
)

func main() {
    logFile := "testlogfile"
    port := "3001"
    if os.Getenv("HTTP_PLATFORM_PORT") != "" {
        logFile = "D:\\home\\site\\wwwroot\\testlogfile"
        port = os.Getenv("HTTP_PLATFORM_PORT")
    }

    f, err := os.OpenFile(logFile, os.O_RDWR | os.O_CREATE | os.O_APPEND, 0666)
           
    http.HandleFunc("/go", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Hello form Go! Error: %v", err)
    })
    
    if err != nil {
        http.ListenAndServe(":"+port, nil)
    } else {
        defer f.Close()
        log.SetOutput(f)
        log.Println("--->   UP @ " + port +"  <------")
    }

    m := martini.Classic()
    m.Get("/m/", func() string {
      return "Hello from martini!"
    })
    m.Map(log.New(f, "[martini]", log.LstdFlags))    
    http.Handle("/m/", m)

    g := gin.Default()
    g.GET("/g/", func(c *gin.Context) {
        c.String(http.StatusOK, "Hello from gin")
    })
    http.Handle("/g/", g)
    
    http.ListenAndServe(":"+port, nil)
}

